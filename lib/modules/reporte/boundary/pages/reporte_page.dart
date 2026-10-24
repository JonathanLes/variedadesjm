/// Gráficas y reporte operativo calculados desde ventas, gastos y existencias reales.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/pill_selector.dart';

enum _Period { semana, mes, anio }

/// Consolida indicadores sin asumir cantidades ni movimientos inexistentes.
class ReportePage extends ConsumerStatefulWidget {
  const ReportePage({super.key});

  @override
  ConsumerState<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends ConsumerState<ReportePage> {
  _Period _period = _Period.mes;

  DateTime get _start {
    final now = DateTime.now();
    switch (_period) {
      case _Period.semana:
        return DateTime(now.year, now.month, now.day - 6);
      case _Period.mes:
        return DateTime(now.year, now.month, 1);
      case _Period.anio:
        return DateTime(now.year, 1, 1);
    }
  }

  String get _periodName => switch (_period) {
        _Period.semana => 'últimos 7 días',
        _Period.mes => 'este mes',
        _Period.anio => 'este año',
      };

  bool _inRange(DateTime date) => !DateTime(date.year, date.month, date.day).isBefore(_start);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ventas = ref.watch(ventasProvider);
    final gastos = ref.watch(gastosProvider);
    final stock = ref.watch(existenciasProvider);
    final details = ref.watch(ventaDetallesProvider);
    final models = ref.watch(zapatosCatalogoProvider);
    final brands = ref.watch(marcasCatalogoProvider);

    final failed = [ventas, gastos, stock, details, models, brands]
        .where((v) => v.hasError)
        .toList();

    Widget body;
    if (failed.isNotEmpty) {
      body = _Message('No se pudo cargar el reporte: ${failed.first.error}');
    } else if (!(ventas.hasValue &&
        gastos.hasValue &&
        stock.hasValue &&
        details.hasValue &&
        models.hasValue &&
        brands.hasValue)) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      try {
        final data = _compute(
          ventas: ventas.requireValue,
          gastos: gastos.requireValue,
          stock: stock.requireValue,
          details: details.requireValue,
          models: models.requireValue,
          brands: brands.requireValue,
        );
        body = _content(context, scheme, data);
      } catch (error, stack) {
        debugPrint('Reporte: error al calcular: $error\n$stack');
        body = _Message('No se pudo calcular el reporte: $error');
      }
    }
    return AppLayout(currentIndex: 4, child: body);
  }

  /// Calcula todos los indicadores del período con datos tipados.
  _ReportData _compute({
    required List<Venta> ventas,
    required List<Gasto> gastos,
    required List<Inventario> stock,
    required List<VentaDetalle> details,
    required List<Zapato> models,
    required List<Marca> brands,
  }) {
    final sales = ventas.where((v) => _inRange(v.fechaVenta)).toList();
    final saleIds = sales.map((v) => v.id).toSet();
    final expenses = gastos.where((g) => _inRange(g.fechaGasto)).toList();
    final income = sales.fold<double>(0, (sum, v) => sum + v.total);
    final outcome = expenses.fold<double>(0, (sum, g) => sum + g.monto);
    final activeStock = stock.where((i) => i.estado == EstadoZapato.activo).length;

    // Pares vendidos por marca dentro del período.
    final stockById = <String, Inventario>{for (final i in stock) i.id: i};
    final modelById = <String, Zapato>{for (final m in models) m.id: m};
    final brandById = <String, String>{for (final b in brands) b.id: b.nombreMarca};
    final byBrand = <String, int>{};
    for (final d in details) {
      if (!saleIds.contains(d.idVenta)) continue;
      final item = stockById[d.idInventario];
      final model = item == null ? null : modelById[item.idZapato];
      final name = (model == null ? null : brandById[model.idMarca]) ?? 'Sin marca';
      byBrand[name] = (byBrand[name] ?? 0) + 1;
    }
    final ranking = byBrand.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Día con más ventas dentro del período.
    final byDay = <DateTime, double>{};
    for (final v in sales) {
      final day = DateTime(v.fechaVenta.year, v.fechaVenta.month, v.fechaVenta.day);
      byDay[day] = (byDay[day] ?? 0) + v.total;
    }
    final bestDay = byDay.isEmpty
        ? null
        : byDay.entries.reduce((a, b) => a.value >= b.value ? a : b);

    return _ReportData(
      income: income,
      outcome: outcome,
      activeStock: activeStock,
      top: ranking.take(5).toList(),
      bestDay: bestDay,
    );
  }

  Widget _content(BuildContext context, ColorScheme scheme, _ReportData data) {
    final top = data.top;
    final bestDay = data.bestDay;
    final income = data.income;
    final outcome = data.outcome;
    final activeStock = data.activeStock;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        Text('Gráficas',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: scheme.primary)),
        const Text('Revisa el rendimiento de tu negocio'),
        const SizedBox(height: 14),
        PillSelector<_Period>(
          values: _Period.values,
          labels: const ['Semana', 'Mes', 'Año'],
          selected: _period,
          onChanged: (value) => setState(() => _period = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _Highlight(
              label: 'Marca más vendida',
              value: top.isEmpty ? '—' : top.first.key,
              trailing: top.isEmpty ? '' : '${top.first.value} pares',
            ),
            const SizedBox(width: 10),
            _Highlight(
              label: 'Mejor día',
              value: bestDay == null ? '—' : longDate(bestDay.key).split(' ').first,
              trailing: bestDay == null ? '' : money(bestDay.value),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Highlight(label: 'Ingresos', value: money(income), color: AppColors.success),
            const SizedBox(width: 10),
            _Highlight(label: 'Egresos', value: money(outcome), color: AppColors.danger),
          ],
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marcas más vendidas · $_periodName',
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                if (top.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Sin ventas en este período.')),
                  )
                else
                  _BarChart(entries: top, color: scheme.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ElevatedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(
              text: 'Reporte Variedades JM ($_periodName)\n'
                  'Ingresos: ${money(income)}\n'
                  'Egresos: ${money(outcome)}\n'
                  'Stock activo: $activeStock'
                  '${top.isEmpty ? '' : '\nMarca más vendida: ${top.first.key} (${top.first.value} pares)'}',
            ));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Resumen copiado al portapapeles')));
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Copiar resumen del reporte'),
        ),
      ],
    );
  }
}

/// Resultado ya calculado del período seleccionado.
class _ReportData {
  final double income;
  final double outcome;
  final int activeStock;
  final List<MapEntry<String, int>> top;
  final MapEntry<DateTime, double>? bestDay;

  const _ReportData({
    required this.income,
    required this.outcome,
    required this.activeStock,
    required this.top,
    required this.bestDay,
  });
}

class _Message extends StatelessWidget {
  final String text;
  const _Message(this.text);

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(text, textAlign: TextAlign.center),
        ),
      );
}

class _Highlight extends StatelessWidget {
  final String label;
  final String value;
  final String trailing;
  final Color? color;

  const _Highlight({
    required this.label,
    required this.value,
    this.trailing = '',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5)),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: color ?? scheme.primary)),
                  ),
                  if (trailing.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(trailing, style: const TextStyle(fontSize: 11.5)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barras verticales con el valor arriba y el nombre de la marca abajo.
class _BarChart extends StatelessWidget {
  final List<MapEntry<String, int>> entries;
  final Color color;

  const _BarChart({required this.entries, required this.color});

  @override
  Widget build(BuildContext context) {
    final maxValue = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    const maxHeight = 130.0;
    return SizedBox(
      height: maxHeight + 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < entries.length; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${entries[i].value}',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Container(
                    width: 30,
                    height: (entries[i].value / maxValue * maxHeight).clamp(6.0, maxHeight),
                    decoration: BoxDecoration(
                      color: i == 0 ? color : color.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(entries[i].key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
