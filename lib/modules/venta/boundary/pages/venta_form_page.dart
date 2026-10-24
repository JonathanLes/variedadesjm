/// Formulario para registrar una venta con uno o varios pares disponibles.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';
import 'package:variedadesjm/shared/widgets/forms/form_section.dart';

/// Persiste una venta validando cliente, monto y pares seleccionados.
class VentaFormPage extends ConsumerStatefulWidget {
  const VentaFormPage({super.key});

  @override
  ConsumerState<VentaFormPage> createState() => _VentaFormPageState();
}

class _VentaFormPageState extends ConsumerState<VentaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _total = TextEditingController();
  String? _clientId;
  final _inventoryIds = <String>{};
  String _payment = 'Efectivo';
  bool _saving = false;

  @override
  void dispose() {
    _total.dispose();
    super.dispose();
  }

  Future<void> _save(List<dynamic> stock) async {
    if (!_formKey.currentState!.validate() || _inventoryIds.isEmpty) return;
    setState(() => _saving = true);
    try {
      final database = await ref.read(sembastDatabaseProvider.future);
      final saleId = DateTime.now().microsecondsSinceEpoch.toString();
      final total = double.parse(_total.text.trim().replaceAll(',', '.'));
      final sale = Venta(
        id: saleId,
        idCliente: _clientId!,
        fechaVenta: DateTime.now(),
        metodoPago: _payment,
        total: total,
      );
      final price = total / _inventoryIds.length;
      await OperationService(database).createSale(
        sale: sale,
        details: _inventoryIds
            .map(
              (id) => VentaDetalle(
                id: '$saleId-$id',
                idVenta: saleId,
                idInventario: id,
                precioVentaFinal: price,
              ),
            )
            .toList(),
      );
      ref
        ..invalidate(ventasProvider)
        ..invalidate(existenciasProvider)
        ..invalidate(ventaDetallesProvider)
        ..invalidate(dashboardDataProvider);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientesProvider);
    final inventory = ref.watch(existenciasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva venta')),
      body: clients.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudieron cargar los clientes: $error')),
        data: (items) => inventory.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('No se pudo cargar el inventario: $error')),
          data: (stock) => Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                FormSection(
                  title: 'Datos de la venta',
                  children: [
                    DropdownButtonFormField<String>(
                      value: _clientId,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      items: items
                          .map((client) => DropdownMenuItem(
                                value: client.id,
                                child: Text('${client.nombre} ${client.apellido}'),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _clientId = value),
                      validator: (value) => value == null ? 'Selecciona un cliente' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _total,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Total'),
                      validator: (value) {
                        final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
                        return amount == null || amount <= 0 ? 'Ingresa un total válido' : null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Text('Pares disponibles (${_inventoryIds.length} seleccionados)'),
                    ...stock.where((item) => item.estado.name == 'activo').map(
                          (item) => CheckboxListTile(
                            value: _inventoryIds.contains(item.id),
                            title: Text('${item.codigo} · talla ${item.talla}'),
                            subtitle: Text(item.color ?? 'Sin color'),
                            onChanged: (selected) => setState(() {
                              if (selected == true) {
                                _inventoryIds.add(item.id);
                              } else {
                                _inventoryIds.remove(item.id);
                              }
                            }),
                          ),
                        ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _payment,
                      decoration: const InputDecoration(labelText: 'Método de pago'),
                      items: const ['Efectivo', 'Transferencia', 'Tarjeta']
                          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) => setState(() => _payment = value!),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _saving || items.isEmpty ? null : () => _save(stock),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(items.isEmpty ? 'Registra un cliente primero' : (_saving ? 'Guardando...' : 'Registrar venta')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
