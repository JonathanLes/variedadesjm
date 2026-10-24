/// Formulario único para registrar una venta o una reserva.
///
/// Ambas operaciones comparten el mismo flujo: buscar el par por código,
/// fijar su precio final, agregarlo a la lista y elegir al cliente. La
/// reserva solo suma el abono inicial y la fecha de vencimiento.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/cliente/boundary/pages/cliente_form_bottom_sheet.dart';
import 'package:variedadesjm/modules/cliente/entity/cliente.dart';
import 'package:variedadesjm/modules/inventario/boundary/pages/inventario_form_page.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/reserva_detalle/entity/reserva_detalle.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';

enum OperationMode { venta, reserva }

class _CartLine {
  final Inventario item;
  final Zapato? zapato;
  final double price;

  const _CartLine({required this.item, required this.zapato, required this.price});

  String get name => zapato?.modelo ?? item.codigo;
}

/// Pantalla de "Nueva venta" / "Nueva reserva" con selector arriba.
class OperationFormPage extends ConsumerStatefulWidget {
  final OperationMode initialMode;

  const OperationFormPage({super.key, this.initialMode = OperationMode.venta});

  @override
  ConsumerState<OperationFormPage> createState() => _OperationFormPageState();
}

class _OperationFormPageState extends ConsumerState<OperationFormPage> {
  final _search = TextEditingController();
  final _price = TextEditingController();
  final _advance = TextEditingController();
  final _phone = TextEditingController();
  final _cart = <_CartLine>[];

  late OperationMode _mode = widget.initialMode;
  Inventario? _selected;
  bool _addClient = false;
  String _payment = 'Efectivo';
  DateTime _expiration = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  bool get _isSale => _mode == OperationMode.venta;
  Color get _modeColor => _isSale ? AppColors.success : AppColors.warning;
  double get _total => _cart.fold(0, (sum, line) => sum + line.price);
  double get _advanceValue => _parse(_advance.text) ?? 0;

  @override
  void dispose() {
    _search.dispose();
    _price.dispose();
    _advance.dispose();
    _phone.dispose();
    super.dispose();
  }

  static double? _parse(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  static String _digits(String text) => text.replaceAll(RegExp(r'\D'), '');

  Cliente? _clientFor(List<Cliente> clients) {
    final digits = _digits(_phone.text);
    if (digits.length < 7) return null;
    for (final client in clients) {
      if (_digits(client.telefono) == digits) return client;
    }
    return null;
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _select(Inventario item, Map<String, Zapato> models) {
    setState(() {
      _selected = item;
      _search.text = item.codigo;
      final suggested = models[item.idZapato]?.precioVentaSugerido ?? 0;
      _price.text = suggested > 0 ? suggested.toStringAsFixed(2) : '';
    });
  }

  void _addToCart(Map<String, Zapato> models) {
    final item = _selected;
    final price = _parse(_price.text);
    if (item == null) return;
    if (price == null || price <= 0) {
      _message('Ingresa un precio final válido.');
      return;
    }
    setState(() {
      _cart.add(_CartLine(item: item, zapato: models[item.idZapato], price: price));
      _selected = null;
      _search.clear();
      _price.clear();
    });
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _expiration,
    );
    if (selected != null) setState(() => _expiration = selected);
  }

  Future<void> _registerClient() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ClienteFormBottomSheet(),
    );
    ref.invalidate(clientesProvider);
  }

  /// Valida el formulario y pide confirmación antes de guardar.
  Future<void> _submit(List<Cliente> clients) async {
    if (_cart.isEmpty) {
      _message('Agrega al menos un par a la lista.');
      return;
    }
    final client = _clientFor(clients);
    final needsClient = !_isSale || _addClient;
    if (needsClient && client == null) {
      _message('Escribe el teléfono de un cliente registrado.');
      return;
    }
    if (!_isSale && (_advanceValue < 0 || _advanceValue > _total)) {
      _message('El abono debe estar entre \$0.00 y ${money(_total)}.');
      return;
    }
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) => _ConfirmSheet(
        title: _isSale ? '¿Confirmar venta?' : '¿Confirmar reserva?',
        rows: [
          ('Pares', '${_cart.length}'),
          ('Cliente', client == null ? 'Cliente general' : '${client.nombre} ${client.apellido}'),
          if (!_isSale) ('Abono', money(_advanceValue)),
          if (!_isSale) ('Restante', money(_total - _advanceValue)),
        ],
        totalLabel: _isSale ? 'Total a pagar' : 'Precio total',
        total: money(_total),
        color: _modeColor,
      ),
    );
    if (confirmed == true) await _save(client);
  }

  Future<void> _save(Cliente? client) async {
    setState(() => _saving = true);
    try {
      final database = await ref.read(sembastDatabaseProvider.future);
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final service = OperationService(database);
      if (_isSale) {
        await service.createSale(
          sale: Venta(
            id: id,
            // Sin cliente registrado la venta queda como "Cliente general".
            idCliente: client?.id ?? '',
            fechaVenta: DateTime.now(),
            metodoPago: _payment,
            total: _total,
          ),
          details: _cart
              .map((line) => VentaDetalle(
                    id: '$id-${line.item.id}',
                    idVenta: id,
                    idInventario: line.item.id,
                    precioVentaFinal: line.price,
                  ))
              .toList(),
        );
      } else {
        await service.createReservation(
          reservation: Reserva(
            id: id,
            idCliente: client!.id,
            fechaReserva: DateTime.now(),
            fechaVencimiento: _expiration,
            adelanto: _advanceValue,
            estado: ReservaEstado.pendiente,
          ),
          details: _cart
              .map((line) => ReservaDetalle(
                    id: '$id-${line.item.id}',
                    idReserva: id,
                    idInventario: line.item.id,
                    precioAcordado: line.price,
                  ))
              .toList(),
        );
      }
      ref
        ..invalidate(ventasProvider)
        ..invalidate(ventaDetallesProvider)
        ..invalidate(reservasProvider)
        ..invalidate(reservaDetallesProvider)
        ..invalidate(existenciasProvider)
        ..invalidate(dashboardDataProvider);
      if (mounted) Navigator.pop(context, true);
    } on InventoryUnavailableException catch (error) {
      if (mounted) _message(error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientesProvider);
    final stockAsync = ref.watch(existenciasProvider);
    final modelsAsync = ref.watch(zapatosCatalogoProvider);
    final failed = [clientsAsync, stockAsync, modelsAsync].where((a) => a.hasError);
    final ready = clientsAsync.hasValue && stockAsync.hasValue && modelsAsync.hasValue;

    return Scaffold(
      appBar: AppBar(title: Text(_isSale ? 'Nueva venta' : 'Nueva reserva')),
      body: failed.isNotEmpty
          ? Center(child: Text('No se pudieron cargar los datos: ${failed.first.error}'))
          : !ready
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(
                  clientsAsync.requireValue,
                  stockAsync.requireValue,
                  {for (final z in modelsAsync.requireValue) z.id: z},
                ),
      bottomNavigationBar: ready
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _modeColor,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: _saving ? null : () => _submit(clientsAsync.requireValue),
                  icon: Icon(_isSale ? Icons.sell_outlined : Icons.schedule_rounded),
                  label: Text(
                    _saving
                        ? 'Guardando...'
                        : _isSale
                            ? 'Realizar venta · ${money(_total)}'
                            : 'Realizar reserva · abono ${money(_advanceValue)}',
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(
    List<Cliente> clients,
    List<Inventario> stock,
    Map<String, Zapato> models,
  ) {
    final query = _search.text.trim().toLowerCase();
    final inCart = _cart.map((line) => line.item.id).toSet();
    final matches = query.isEmpty || _selected != null
        ? <Inventario>[]
        : stock
            .where((item) =>
                item.estado == EstadoZapato.activo &&
                !inCart.contains(item.id) &&
                (item.codigo.toLowerCase().contains(query) ||
                    (models[item.idZapato]?.modelo.toLowerCase().contains(query) ?? false)))
            .take(5)
            .toList();
    final client = _clientFor(clients);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        SegmentedButton<OperationMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: OperationMode.venta,
              icon: Icon(Icons.sell_outlined),
              label: Text('Venta'),
            ),
            ButtonSegment(
              value: OperationMode.reserva,
              icon: Icon(Icons.schedule_rounded),
              label: Text('Reserva'),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (value) => setState(() => _mode = value.first),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? _modeColor : null,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? Colors.white : null,
            ),
          ),
        ),
        const _Label('Producto'),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() => _selected = null),
          decoration: InputDecoration(
            hintText: 'Escribe el código o el modelo',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => setState(() {
                      _search.clear();
                      _selected = null;
                    }),
                  ),
          ),
        ),
        if (query.isNotEmpty && _selected == null && matches.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.danger),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'No encontramos ese código entre los pares disponibles.',
                        style: TextStyle(color: AppColors.danger, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InventarioFormPage()),
                    );
                    ref.invalidate(existenciasProvider);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Registrar nuevo par'),
                ),
              ],
            ),
          ),
        for (final item in matches)
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              onTap: () => _select(item, models),
              title: Text(models[item.idZapato]?.modelo ?? 'Par sin modelo',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${item.codigo} · ${_detail(item)}'),
              trailing: Text(
                money(models[item.idZapato]?.precioVentaSugerido ?? 0),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        if (_selected != null) ...[
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(models[_selected!.idZapato]?.modelo ?? 'Par sin modelo',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${_selected!.codigo} · ${_detail(_selected!)}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Sugerido', style: TextStyle(fontSize: 11)),
                  Text(
                    money(models[_selected!.idZapato]?.precioVentaSugerido ?? 0),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const _Label('Precio final'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(prefixText: '\$ '),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToCart(models),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ],
        _Label('${_isSale ? 'Productos de la venta' : 'Productos de la reserva'} (${_cart.length})'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: _cart.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text('Aún no has agregado productos')),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < _cart.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_cart[i].name,
                                        style: const TextStyle(fontWeight: FontWeight.w700)),
                                    Text('${_cart[i].item.codigo} · ${_detail(_cart[i].item)}',
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(money(_cart[i].price),
                                  style: const TextStyle(fontWeight: FontWeight.w800)),
                              IconButton(
                                tooltip: 'Quitar',
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () => setState(() => _cart.removeAt(i)),
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      Row(
                        children: [
                          Text(_isSale ? 'Total a pagar' : 'Precio total',
                              style: const TextStyle(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Text(money(_total),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: _modeColor)),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        if (_isSale) ...[
          const _Label('Método de pago'),
          Wrap(
            spacing: 8,
            children: [
              for (final method in const ['Efectivo', 'Transferencia', 'Tarjeta'])
                ChoiceChip(
                  label: Text(method),
                  selected: _payment == method,
                  onSelected: (_) => setState(() => _payment = method),
                ),
            ],
          ),
        ] else ...[
          const _Label('Abono inicial'),
          TextField(
            controller: _advance,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(prefixText: '\$ ', hintText: '0.00'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Text('Restante'),
                const Spacer(),
                Text(money((_total - _advanceValue).clamp(0, double.infinity)),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.warning)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Fecha de vencimiento'),
            subtitle: Text(shortDate(_expiration)),
            trailing: const Icon(Icons.calendar_month_outlined),
            onTap: _pickDate,
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _isSale ? 'Cliente (opcional)' : 'Cliente (obligatorio)',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                ),
              ),
              if (_isSale) ...[
                const Text('Agregar cliente', style: TextStyle(fontSize: 12.5)),
                Switch(
                  value: _addClient,
                  onChanged: (value) => setState(() => _addClient = value),
                ),
              ],
            ],
          ),
        ),
        if (!_isSale || _addClient) ...[
          TextField(
            controller: _phone,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Teléfono del cliente',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          if (client != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  label: Text('${client.nombre} ${client.apellido} · cliente registrado'),
                ),
              ),
            )
          else if (_digits(_phone.text).length >= 7)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  const Expanded(child: Text('Ese teléfono no está registrado.')),
                  TextButton(onPressed: _registerClient, child: const Text('Registrar cliente')),
                ],
              ),
            ),
        ],
      ],
    );
  }

  String _detail(Inventario item) => [
        if ((item.color ?? '').isNotEmpty) item.color!,
        'Talla ${item.talla}',
      ].join(' · ');
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
      );
}

/// Hoja de confirmación con el resumen de lo que se va a guardar.
class _ConfirmSheet extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;
  final String totalLabel;
  final String total;
  final Color color;

  const _ConfirmSheet({
    required this.title,
    required this.rows,
    required this.totalLabel,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(row.$1),
                    const Spacer(),
                    Text(row.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            const Divider(height: 24),
            Row(
              children: [
                Text(totalLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                Text(total,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Revisar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
