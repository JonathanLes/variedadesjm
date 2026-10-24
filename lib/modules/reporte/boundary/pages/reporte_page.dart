/// Reporte operativo calculado desde ventas, gastos y existencias reales.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/dashboard/activity_chart.dart';
import 'package:variedadesjm/shared/widgets/dashboard/stat_card.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';

/// Consolida indicadores sin asumir cantidades ni movimientos inexistentes.
class ReportePage extends ConsumerStatefulWidget {
  const ReportePage({super.key});

  @override
  ConsumerState<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends ConsumerState<ReportePage> {
  DateTimeRange? _range;

  Future<void> _selectRange() async {
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _range,
    );
    if (selected != null) setState(() => _range = selected);
  }

  @override
  Widget build(BuildContext context) {
    final ventas = ref.watch(ventasProvider);
    final gastos = ref.watch(gastosProvider);
    final inventario = ref.watch(existenciasProvider);
    return AppLayout(
      currentIndex: 4,
      child: ventas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('No se pudo cargar el reporte: $error')),
        data: (ventaItems) => gastos.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('No se pudo cargar el reporte: $error')),
          data: (gastoItems) => inventario.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('No se pudo cargar el reporte: $error')),
            data: (stockItems) {
              final filteredSales = ventaItems
                  .where((item) => _range == null || _inRange(item.fechaVenta))
                  .toList();
              final filteredExpenses = gastoItems
                  .where((item) => _range == null || _inRange(item.fechaGasto))
                  .toList();
              final ingresos = filteredSales.fold<double>(
                0,
                (sum, item) => sum + item.total,
              );
              final egresos = filteredExpenses.fold<double>(
                0,
                (sum, item) => sum + item.monto,
              );
              final activos = stockItems
                  .where((item) => item.estado.name == 'activo')
                  .length;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Reportes',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _selectRange,
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(
                          _range == null
                              ? 'Todo el período'
                              : '${_range!.start.day}/${_range!.start.month} - ${_range!.end.day}/${_range!.end.month}',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Clipboard.setData(
                          ClipboardData(
                            text: _summary(ingresos, egresos, activos),
                          ),
                        ),
                        icon: const Icon(Icons.copy_outlined),
                        label: const Text('Copiar resumen'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  GridView.count(
                    crossAxisCount: MediaQuery.sizeOf(context).width > 700
                        ? 3
                        : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.5,
                    children: [
                      StatCard(
                        label: 'Ingresos',
                        value: '\$ ${ingresos.toStringAsFixed(2)}',
                        icon: Icons.trending_up,
                        color: Colors.teal,
                      ),
                      StatCard(
                        label: 'Egresos',
                        value: '\$ ${egresos.toStringAsFixed(2)}',
                        icon: Icons.trending_down,
                        color: Colors.orange,
                      ),
                      StatCard(
                        label: 'Stock activo',
                        value: '$activos',
                        icon: Icons.inventory_2_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ActivityChart(
                    values: _lastSevenDays(filteredSales),
                    labels: _dayLabels(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _inRange(DateTime date) {
    final range = _range;
    if (range == null) return true;
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
    );
    return !day.isBefore(start) && !day.isAfter(end);
  }

  String _summary(double income, double expenses, int stock) =>
      'Reporte Variedades JM\nIngresos: \$${income.toStringAsFixed(2)}\nEgresos: \$${expenses.toStringAsFixed(2)}\nStock activo: $stock';
}

List<double> _lastSevenDays(List<Venta> ventas) {
  final today = DateTime.now();
  return List.generate(7, (index) {
    final day = DateTime(today.year, today.month, today.day - (6 - index));
    return ventas
        .where((item) {
          final date = item.fechaVenta;
          return date.year == day.year &&
              date.month == day.month &&
              date.day == day.day;
        })
        .fold<double>(0, (sum, item) => sum + item.total);
  });
}

List<String> _dayLabels() {
  const names = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  final today = DateTime.now();
  return List.generate(
    7,
    (index) =>
        names[DateTime(
              today.year,
              today.month,
              today.day - (6 - index),
            ).weekday -
            1],
  );
}
