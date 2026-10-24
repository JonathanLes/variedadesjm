/// Pantalla de ventas construida a partir de las ventas persistidas localmente.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/lists/record_list_tile.dart';
import 'venta_form_page.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';

/// Lista ventas reales y muestra un estado vacío cuando aún no existen.
class VentaPage extends ConsumerWidget {
  const VentaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ventasProvider);
    return AppLayout(
      showFab: false,
      currentIndex: 1,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const VentaFormPage()));
            ref.invalidate(ventasProvider);
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva venta'),
        ),
        body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudieron cargar las ventas: $error')),
        data: (ventas) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Ventas', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${ventas.length} ventas registradas'),
            const SizedBox(height: 18),
            if (ventas.isEmpty)
              const _EmptyModule(message: 'Aún no hay ventas registradas.')
            else
              ...ventas.map((venta) => RecordListTile(
                    title: 'Venta ${venta.id}',
                    subtitle: '${_formatDate(venta.fechaVenta)} · ${venta.metodoPago}',
                    trailing: _money(venta.total),
                    icon: Icons.sell_outlined,
                    onLongPress: () => _delete(context, ref, venta.id),
                  )),
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
        title: const Text('Eliminar venta'),
        content: const Text('Se eliminará la venta y el par volverá a estar disponible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed != true) return;
    final database = await ref.read(sembastDatabaseProvider.future);
    await OperationService(database).deleteSale(id);
    ref.invalidate(ventasProvider);
    ref.invalidate(existenciasProvider);
    ref.invalidate(dashboardDataProvider);
  }
}

String _money(double value) => '\$ ${value.toStringAsFixed(2)}';
String _formatDate(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

class _EmptyModule extends StatelessWidget {
  final String message;
  const _EmptyModule({required this.message});

  @override
  Widget build(BuildContext context) => SizedBox(height: 240, child: Center(child: Text(message)));
}
