/// Detalle de una reserva: cliente, pares, pago, nuevo abono y cierre.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/reserva/controller/reserva_resumen_provider.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/status_chip.dart';

/// Pantalla para dar seguimiento y cerrar una reserva.
class ReservaDetailPage extends ConsumerStatefulWidget {
  final String reservaId;

  const ReservaDetailPage({super.key, required this.reservaId});

  @override
  ConsumerState<ReservaDetailPage> createState() => _ReservaDetailPageState();
}

class _ReservaDetailPageState extends ConsumerState<ReservaDetailPage> {
  final _amount = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _refresh() {
    ref
      ..invalidate(reservasProvider)
      ..invalidate(reservaDetallesProvider)
      ..invalidate(ventasProvider)
      ..invalidate(ventaDetallesProvider)
      ..invalidate(existenciasProvider)
      ..invalidate(dashboardDataProvider);
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _run(Future<void> Function(OperationService service) action) async {
    setState(() => _busy = true);
    try {
      final database = await ref.read(sembastDatabaseProvider.future);
      await action(OperationService(database));
      _refresh();
    } on InventoryUnavailableException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addPayment(ReservaResumen item, [double? fixed]) async {
    final amount = fixed ?? double.tryParse(_amount.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      _message('Ingresa un monto válido.');
      return;
    }
    if (amount > item.restante) {
      _message('El abono no puede superar el restante (${money(item.restante)}).');
      return;
    }
    await _run((service) => service.addReservationPayment(item.reserva.id, amount));
    _amount.clear();
  }

  Future<bool> _confirm(String title, String body, String action, {bool danger = false}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Volver')),
          FilledButton(
            style: danger ? FilledButton.styleFrom(backgroundColor: AppColors.danger) : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _complete(ReservaResumen item) async {
    final ok = await _confirm(
      'Completar venta',
      'La reserva se convertirá en una venta por ${money(item.total)} y los pares quedarán como vendidos.',
      'Completar',
    );
    if (!ok) return;
    await _run((service) => service.completeReservation(item.reserva.id));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _cancel(ReservaResumen item) async {
    final ok = await _confirm(
      'Cancelar reserva',
      'Los pares volverán a estar disponibles en el inventario.',
      'Cancelar reserva',
      danger: true,
    );
    if (!ok) return;
    await _run((service) => service.cancelReservation(item.reserva.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reservasResumenProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de reserva')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudo cargar la reserva: $error')),
        data: (all) {
          final matches = all.where((r) => r.reserva.id == widget.reservaId);
          if (matches.isEmpty) {
            return const Center(child: Text('Esta reserva ya no existe.'));
          }
          return _body(matches.first);
        },
      ),
    );
  }

  Widget _body(ReservaResumen item) {
    final scheme = Theme.of(context).colorScheme;
    final progress = item.total <= 0 ? 0.0 : (item.abonado / item.total).clamp(0.0, 1.0);
    final canPay = item.pendiente && !_busy;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Reserva del ${shortDate(item.reserva.fechaReserva)}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            StatusChip(
              label: item.pendiente ? (item.pagada ? 'Pagada' : 'Pendiente') : 'Cancelada',
              tone: item.pendiente
                  ? (item.pagada ? StatusTone.success : StatusTone.warning)
                  : StatusTone.danger,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scheme.primary.withValues(alpha: .10),
              foregroundColor: scheme.primary,
              child: const Icon(Icons.person_outline),
            ),
            title: Text(item.clienteNombre,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(item.telefono),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Calzado reservado',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                for (final line in item.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(line.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text('${line.codigo} · ${line.detalle}',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(money(line.precio),
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                const Divider(height: 20),
                Text('Vence el ${shortDate(item.reserva.fechaVencimiento)}',
                    style: TextStyle(
                        color: item.porVencer ? AppColors.danger : null,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Pago',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text('Total ${money(item.total)}',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    color: AppColors.warning,
                    backgroundColor: AppColors.warning.withValues(alpha: .18),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Abonado', style: TextStyle(fontSize: 12)),
                        Text(money(item.abonado),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Restante', style: TextStyle(fontSize: 12)),
                        Text(money(item.restante),
                            style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: AppColors.warning)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (item.pendiente && !item.pagada) ...[
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Registrar nuevo abono',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amount,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(prefixText: '\$ ', hintText: '0.00'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton.icon(
                          onPressed: canPay ? () => _addPayment(item) : null,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Registrar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final quick in const [5.0, 10.0])
                        if (quick < item.restante)
                          ActionChip(
                            label: Text('\$${quick.toStringAsFixed(0)}'),
                            onPressed: canPay ? () => _addPayment(item, quick) : null,
                          ),
                      ActionChip(
                        label: Text('Saldar ${money(item.restante)}'),
                        onPressed: canPay ? () => _addPayment(item, item.restante) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        if (item.pendiente) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: item.pagada && !_busy ? () => _complete(item) : null,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Completar venta'),
          ),
          if (!item.pagada)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Center(
                child: Text('Se habilita al saldar el restante',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: _busy ? null : () => _cancel(item),
            child: const Text('Cancelar reserva'),
          ),
        ],
      ],
    );
  }
}
