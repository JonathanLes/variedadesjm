/// Pantalla de reservas con vencimiento y estado provenientes de la base local.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/lists/record_list_tile.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'reserva_form_page.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';

/// Muestra reservas pendientes y canceladas sin datos de ejemplo.
class ReservaPage extends ConsumerWidget {
  const ReservaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservasProvider);
    return AppLayout(
      showFab: false,
      currentIndex: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReservaFormPage()),
            );
            ref.invalidate(reservasProvider);
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva reserva'),
        ),
        body: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('No se pudieron cargar las reservas: $error')),
          data: (reservas) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Reservas',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text('${reservas.length} reservas registradas'),
              const SizedBox(height: 18),
              if (reservas.isEmpty)
                const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text('Aún no hay reservas registradas.'),
                  ),
                )
              else
                ...reservas.map(
                  (reserva) => RecordListTile(
                    title: 'Reserva ${reserva.id}',
                    subtitle:
                        'Vence ${reserva.fechaVencimiento.day}/${reserva.fechaVencimiento.month}/${reserva.fechaVencimiento.year} · ${reserva.estado.name}',
                    trailing: '\$ ${reserva.adelanto.toStringAsFixed(2)}',
                    icon: Icons.bookmark_outline,
                    color: Colors.teal,
                    onLongPress: () =>
                        _actions(context, ref, reserva.id, reserva.estado),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar reserva'),
        content: const Text(
          'Se eliminará la reserva y el par volverá a estar disponible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final database = await ref.read(sembastDatabaseProvider.future);
    await OperationService(database).deleteReservation(id);
    ref.invalidate(reservasProvider);
    ref.invalidate(existenciasProvider);
    ref.invalidate(dashboardDataProvider);
  }

  Future<void> _actions(
    BuildContext context,
    WidgetRef ref,
    String id,
    ReservaEstado status,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (status == ReservaEstado.pendiente)
              ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: const Text('Cancelar reserva'),
                onTap: () => Navigator.pop(context, 'cancel'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Eliminar reserva'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'delete') {
      await _delete(context, ref, id);
      return;
    }
    final database = await ref.read(sembastDatabaseProvider.future);
    await OperationService(database).cancelReservation(id);
    ref
      ..invalidate(reservasProvider)
      ..invalidate(existenciasProvider)
      ..invalidate(dashboardDataProvider);
  }
}
