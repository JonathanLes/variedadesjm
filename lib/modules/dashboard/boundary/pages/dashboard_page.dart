/// Presenta el resumen operativo usando únicamente datos persistidos.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/widgets/dashboard/activity_chart.dart';
import 'package:variedadesjm/shared/widgets/dashboard/stat_card.dart';
import 'package:variedadesjm/modules/gasto/boundary/pages/gasto_form_page.dart';
import 'package:variedadesjm/modules/venta/boundary/pages/venta_form_page.dart';
import 'package:variedadesjm/modules/reserva/boundary/pages/reserva_form_page.dart';

/// Dashboard principal de Variedades JM.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return AppLayout(
      currentIndex: 0,
      child: ref.watch(dashboardDataProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('No se pudo cargar el resumen: $error')),
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Buenos días, equipo',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text('Este es el resumen de tu tienda hoy.'),
            const SizedBox(height: 22),
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                StatCard(label: 'Ventas del día', value: _money(_todaySales(data.ventas)), icon: Icons.trending_up, color: scheme.primary),
                StatCard(label: 'Pares en stock', value: '${data.existencias.length}', icon: Icons.inventory_2_outlined, color: scheme.secondary),
                StatCard(label: 'Reservas activas', value: '${data.reservas.where((item) => item.estado.name == 'pendiente').length}', icon: Icons.bookmark_outline, color: Colors.orange),
                StatCard(label: 'Gastos del día', value: _money(_todayExpenses(data.gastos)), icon: Icons.receipt_long_outlined, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 18),
            ActivityChart(values: _lastSevenDays(data.ventas), labels: _dayLabels()),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.sell_outlined),
                      label: const Text('Nueva venta'),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VentaFormPage())),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.bookmark_outline),
                      label: const Text('Nueva reserva'),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservaFormPage())),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.receipt_long_outlined),
                      label: const Text('Registrar gasto'),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GastoFormPage())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _todaySales(List<Venta> ventas) {
  final now = DateTime.now();
  return ventas.where((item) => _sameDate(item.fechaVenta, now)).fold(0, (sum, item) => sum + item.total);
}

double _todayExpenses(List<Gasto> gastos) {
  final now = DateTime.now();
  return gastos.where((item) => _sameDate(item.fechaGasto, now)).fold(0, (sum, item) => sum + item.monto);
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month && first.day == second.day;

String _money(double value) => '\$ ${value.toStringAsFixed(2)}';

List<double> _lastSevenDays(List<Venta> ventas) {
  final today = DateTime.now();
  return List.generate(7, (index) {
    final day = DateTime(today.year, today.month, today.day - (6 - index));
    return ventas.where((item) => _sameDate(item.fechaVenta, day)).fold<double>(0, (sum, item) => sum + item.total);
  });
}

List<String> _dayLabels() {
  const names = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  final today = DateTime.now();
  return List.generate(7, (index) => names[DateTime(today.year, today.month, today.day - (6 - index)).weekday - 1]);
}
