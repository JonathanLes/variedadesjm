/// Formulario para registrar una reserva con uno o varios pares disponibles.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/reserva_detalle/entity/reserva_detalle.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';
import 'package:variedadesjm/shared/widgets/forms/form_section.dart';

/// Valida y persiste reservas pendientes con sus pares asociados.
class ReservaFormPage extends ConsumerStatefulWidget {
  const ReservaFormPage({super.key});

  @override
  ConsumerState<ReservaFormPage> createState() => _ReservaFormPageState();
}

class _ReservaFormPageState extends ConsumerState<ReservaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _advance = TextEditingController();
  String? _clientId;
  final _inventoryIds = <String>{};
  DateTime _expiration = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _advance.dispose();
    super.dispose();
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

  Future<void> _save(List<dynamic> stock) async {
    if (!_formKey.currentState!.validate() || _inventoryIds.isEmpty) return;
    setState(() => _saving = true);
    try {
      final database = await ref.read(sembastDatabaseProvider.future);
      final reservationId = DateTime.now().microsecondsSinceEpoch.toString();
      final advance = double.parse(_advance.text.trim().replaceAll(',', '.'));
      final reservation = Reserva(
        id: reservationId,
        idCliente: _clientId!,
        fechaReserva: DateTime.now(),
        fechaVencimiento: _expiration,
        adelanto: advance,
        estado: ReservaEstado.pendiente,
      );
      final price = advance / _inventoryIds.length;
      await OperationService(database).createReservation(
        reservation: reservation,
        details: _inventoryIds
            .map(
              (id) => ReservaDetalle(
                id: '$reservationId-$id',
                idReserva: reservationId,
                idInventario: id,
                precioAcordado: price,
              ),
            )
            .toList(),
      );
      ref
        ..invalidate(reservasProvider)
        ..invalidate(existenciasProvider)
        ..invalidate(reservaDetallesProvider)
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
      appBar: AppBar(title: const Text('Nueva reserva')),
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
                  title: 'Datos de la reserva',
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
                      controller: _advance,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Adelanto'),
                      validator: (value) {
                        final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
                        return amount == null || amount < 0 ? 'Ingresa un adelanto válido' : null;
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
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fecha de vencimiento'),
                      subtitle: Text('${_expiration.day}/${_expiration.month}/${_expiration.year}'),
                      trailing: const Icon(Icons.calendar_month_outlined),
                      onTap: _pickDate,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _saving || items.isEmpty ? null : () => _save(stock),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(items.isEmpty ? 'Registra un cliente primero' : (_saving ? 'Guardando...' : 'Registrar reserva')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
