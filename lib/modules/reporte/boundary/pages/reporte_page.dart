/// Gráficas del negocio calculadas desde ventas, gastos e inventario reales.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/marca/controller/marca_controller.dart';
import 'package:variedadesjm/modules/reporte/controller/reporte_calculator.dart';
import 'package:variedadesjm/modules/reporte/service/pdf_export.dart';
import 'package:variedadesjm/modules/reporte/service/reporte_pdf.dart';
import 'package:variedadesjm/modules/zapato/controller/zapato_controller.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/charts/charts.dart';
import 'package:variedadesjm/shared/widgets/ui/pill_selector.dart';

class ReportePage extends ConsumerStatefulWidget {
  const ReportePage({super.key});

  @override
  ConsumerState<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends ConsumerState<ReportePage> {
  ReportePeriodo _periodo = ReportePeriodo.mes;

  @override
  Widget build(BuildContext context) {
    final ventas = ref.watch(ventasProvider);
    final gastos = ref.watch(gastosProvider);
    final stock = ref.watch(existenciasProvider);
    final detalles = ref.watch(ventaDetallesProvider);
    final modelos = ref.watch(zapatosCatalogoProvider);
    final marcas = ref.watch(marcasCatalogoProvider);
    final todos = [ventas, gastos, stock, detalles, modelos, marcas];

    Widget body;
    final fallidos = todos.where((v) => v.hasError).toList();
    if (fallidos.isNotEmpty) {
      body = _Mensaje('No se pudo cargar el reporte: ${fallidos.first.error}');
    } else if (!todos.every((v) => v.hasValue)) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      try {
        final data = calcularReporte(
          hoy: DateTime.now(),
          periodo: _periodo,
          ventas: ventas.requireValue,
          detalles: detalles.requireValue,
          gastos: gastos.requireValue,
          inventario: stock.requireValue,
          zapatos: modelos.requireValue,
          marcas: marcas.requireValue,
        );
        body = _contenido(context, data);
      } catch (error, stack) {
        debugPrint('Reporte: error al calcular: $error\n$stack');
        body = _Mensaje('No se pudo calcular el reporte: $error');
      }
    }
    return AppLayout(currentIndex: 4, child: body);
  }

  Widget _contenido(BuildContext context, ReporteData d) {
    final primary = Theme.of(context).colorScheme.primary;
    String dinero(double v) => money(v);
    String pares(double v) => v.toStringAsFixed(0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gráficas',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800, color: primary)),
                  const Text('Revisa el rendimiento de tu negocio'),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => exportarPdf(
                context,
                titulo: 'Reporte de ventas - ${_periodo.nombre}',
                archivo: 'reporte_${_periodo.name}_${_fechaArchivo()}.pdf',
                construir: () => construirReportePdf(d, _periodo.nombre),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: const Text('PDF'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        PillSelector<ReportePeriodo>(
          values: ReportePeriodo.values,
          labels: [for (final p in ReportePeriodo.values) p.etiqueta],
          selected: _periodo,
          onChanged: (p) => setState(() => _periodo = p),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _Resumen(
                etiqueta: 'Ingresos', valor: money(d.ingresos), color: AppColors.success),
            const SizedBox(width: 10),
            _Resumen(
                etiqueta: 'Egresos', valor: money(d.egresos), color: AppColors.danger),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Resumen(
              etiqueta: 'Utilidad',
              valor: money(d.utilidad),
              color: d.utilidad < 0 ? AppColors.danger : null,
            ),
            const SizedBox(width: 10),
            _Resumen(
              etiqueta: 'Pares vendidos',
              valor: '${d.paresVendidos}',
              pie: d.mejorDia == null ? null : 'Mejor día: ${d.mejorDia!.nombre}',
            ),
          ],
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Ventas y gastos',
          subtitle: _periodo.nombre,
          isEmpty: d.ingresos == 0 && d.egresos == 0,
          child: GroupedBarChart(
            groups: [for (final b in d.tendencia) (label: b.etiqueta, a: b.ventas, b: b.gastos)],
            aName: 'Ventas',
            bName: 'Gastos',
            aColor: AppColors.success,
            bColor: AppColors.danger,
          ),
        ),
        ChartCard(
          title: 'Marcas más vendidas',
          subtitle: 'Pares vendidos · ${_periodo.nombre}',
          isEmpty: d.marcas.isEmpty,
          child: VBarChart(
            items: [for (final m in d.marcas) (label: m.nombre, value: m.valor)],
            format: pares,
          ),
        ),
        ChartCard(
          title: 'Modelos más vendidos',
          subtitle: 'Pares vendidos · ${_periodo.nombre}',
          isEmpty: d.productos.isEmpty,
          child: HBarList(
            items: [for (final p in d.productos) (label: p.nombre, value: p.valor)],
            format: pares,
          ),
        ),
        ChartCard(
          title: 'Ventas por día de la semana',
          subtitle: 'Te dice cuándo conviene tener más producto y atención',
          isEmpty: d.ingresos == 0,
          child: VBarChart(
            items: [for (final x in d.diasSemana) (label: x.nombre, value: x.valor)],
            format: (v) => '\$${v.toStringAsFixed(0)}',
          ),
        ),
        ChartCard(
          title: 'Tallas más vendidas',
          subtitle: 'Pares vendidos · ${_periodo.nombre}',
          isEmpty: d.tallas.isEmpty,
          child: VBarChart(
            items: [for (final t in d.tallas) (label: t.nombre, value: t.valor)],
            format: pares,
          ),
        ),
        ChartCard(
          title: 'Cómo te pagan',
          subtitle: 'Ventas por método de pago',
          isEmpty: d.metodosPago.isEmpty,
          child: DonutChart(
            items: [for (final m in d.metodosPago) (label: m.nombre, value: m.valor)],
            format: dinero,
          ),
        ),
        ChartCard(
          title: 'En qué gastas',
          subtitle: 'Gastos por concepto · ${_periodo.nombre}',
          isEmpty: d.gastosPorConcepto.isEmpty,
          child: DonutChart(
            items: [for (final g in d.gastosPorConcepto) (label: g.nombre, value: g.valor)],
            format: dinero,
          ),
        ),
        ChartCard(
          title: 'Estado del inventario',
          subtitle: 'Todos los pares registrados',
          isEmpty: d.stockActivo + d.stockReservado + d.stockVendido == 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DonutChart(
                items: [
                  (label: 'Disponibles', value: d.stockActivo.toDouble()),
                  (label: 'Reservados', value: d.stockReservado.toDouble()),
                  (label: 'Vendidos', value: d.stockVendido.toDouble()),
                ],
                format: pares,
                centerText: '${d.stockActivo + d.stockReservado + d.stockVendido}\npares',
              ),
              if (d.stockLento > 0) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${d.stockLento} pares llevan más de 60 días sin venderse '
                        '(${money(d.stockLentoValor)} al costo). Considera una oferta.',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _fechaArchivo() {
    final n = DateTime.now();
    return '${n.year}${n.month.toString().padLeft(2, '0')}${n.day.toString().padLeft(2, '0')}';
  }
}

class _Mensaje extends StatelessWidget {
  final String texto;

  const _Mensaje(this.texto);

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(texto)),
      );
}

class _Resumen extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final String? pie;
  final Color? color;

  const _Resumen({required this.etiqueta, required this.valor, this.pie, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(etiqueta, style: TextStyle(fontSize: 12, color: context.muted)),
              const SizedBox(height: 2),
              Text(valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color ?? context.brand,
                  )),
              if (pie != null)
                Text(pie!, style: TextStyle(fontSize: 11.5, color: context.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
