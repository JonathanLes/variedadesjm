/// Pantalla de ventas construida a partir de las ventas persistidas localmente.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/inventario/controller/inventario_controller.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/modules/venta/service/venta_filtros.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/lists/record_list_tile.dart';
import 'package:variedadesjm/shared/widgets/ui/pill_selector.dart';
import 'venta_form_page.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/data/operation_service.dart';

/// Lista ventas con filtros por fecha: pastillas (Hoy, Semana, Mes, Todas) y un día del calendario.
class VentaPage extends ConsumerStatefulWidget {
  const VentaPage({super.key});

  @override
  ConsumerState<VentaPage> createState() => _VentaPageState();
}

class _VentaPageState extends ConsumerState<VentaPage> {
  VentaRango _rango = VentaRango.hoy;

  /// Día elegido en el calendario; cuando existe, manda sobre las pastillas.
  DateTime? _dia;

  Future<void> _elegirDia() async {
    final ahora = DateTime.now();
    final elegido = await showDatePicker(
      context: context,
      initialDate: _dia ?? ahora,
      firstDate: DateTime(2020),
      lastDate: ahora,
      helpText: 'Elige un día',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (elegido != null) setState(() => _dia = elegido);
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final state = ref.watch(ventasProvider);
    final scheme = Theme.of(context).colorScheme;
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
          data: (todas) {
            final hoy = DateTime.now();
            final ventas = todas
                .where((v) => _dia != null
                    ? ventaEnDia(v.fechaVenta, _dia!)
                    : ventaEnRango(v.fechaVenta, _rango, hoy))
                .toList();
            final total = ventas.fold<double>(0, (suma, v) => suma + v.total);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              children: [
                Text('Ventas',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PillSelector<VentaRango?>(
                        values: VentaRango.values,
                        labels: [for (final r in VentaRango.values) r.etiqueta],
                        // Con un día elegido ninguna pastilla queda marcada.
                        selected: _dia != null ? null : _rango,
                        onChanged: (r) {
                          if (r == null) return;
                          setState(() {
                            _rango = r;
                            _dia = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Elegir un día',
                      icon: const Icon(Icons.calendar_month_rounded),
                      onPressed: _elegirDia,
                    ),
                  ],
                ),
                if (_dia != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      avatar: Icon(Icons.event_rounded, size: 18, color: scheme.primary),
                      label: Text(longDate(_dia!)),
                      onPressed: _elegirDia,
                      onDeleted: () => setState(() => _dia = null),
                      deleteButtonTooltipMessage: 'Quitar el día',
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(Icons.sell_outlined, color: scheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ventas.length == 1 ? '1 venta' : '${ventas.length} ventas',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(_money(total),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: scheme.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (ventas.isEmpty)
                  _EmptyModule(
                    message: todas.isEmpty
                        ? 'Aún no hay ventas registradas.'
                        : 'No hay ventas en este periodo.',
                  )
                else
                  ...ventas.map((venta) => RecordListTile(
                        title: 'Venta ${venta.id}',
                        subtitle: '${_formatDate(venta.fechaVenta)} · ${venta.metodoPago}',
                        trailing: _money(venta.total),
                        icon: Icons.sell_outlined,
                        onLongPress: () => _delete(context, ref, venta.id),
                      )),
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
    refrescarInventario(ref);
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
