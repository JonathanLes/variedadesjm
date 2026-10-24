/// Pantalla de gastos basada exclusivamente en registros persistidos.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/lists/record_list_tile.dart';
import 'gasto_form_page.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/data/app_record_writer.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';

/// Resume los gastos registrados y su total calculado.
class GastoPage extends ConsumerWidget {
  const GastoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gastosProvider);
    return AppLayout(
      showFab: false,
      currentIndex: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GastoFormPage()),
            );
            ref.invalidate(gastosProvider);
          },
          icon: const Icon(Icons.add),
          label: const Text('Nuevo gasto'),
        ),
        body: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('No se pudieron cargar los gastos: $error')),
          data: (gastos) {
            final total = gastos.fold<double>(
              0,
              (sum, gasto) => sum + gasto.monto,
            );
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Gastos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Total registrado: \$ ${total.toStringAsFixed(2)}'),
                const SizedBox(height: 18),
                if (gastos.isEmpty)
                  const SizedBox(
                    height: 240,
                    child: Center(
                      child: Text('Aún no hay gastos registrados.'),
                    ),
                  )
                else
                  ...gastos.map(
                    (gasto) => RecordListTile(
                      title: gasto.descripcion,
                      subtitle:
                          '${gasto.fechaGasto.day}/${gasto.fechaGasto.month}/${gasto.fechaGasto.year} · ${gasto.metodoPago}',
                      trailing: '\$ ${gasto.monto.toStringAsFixed(2)}',
                      icon: Icons.receipt_long_outlined,
                      color: Colors.orange,
                      onLongPress: () => _delete(context, ref, gasto.id),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: const Text('Esta acción no se puede deshacer.'),
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
    await deleteRecord(
      database: database,
      storeName: SembastStores.gasto,
      id: id,
    );
    ref.invalidate(gastosProvider);
    ref.invalidate(dashboardDataProvider);
  }
}
