/// Gráficas sencillas dibujadas con widgets de Flutter (sin paquetes externos).
///
/// Todas se adaptan al modo claro/oscuro y muestran los valores escritos, no
/// solo el color, para que se entiendan de un vistazo.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Colores para series categóricas (legibles en modo claro y oscuro).
const chartPalette = <Color>[
  Color(0xFF3A6EA5),
  Color(0xFF1E9E6A),
  Color(0xFFE08A00),
  Color(0xFF7B61C9),
  Color(0xFFC8412F),
  Color(0xFF8A94A6),
];

/// Tarjeta que enmarca una gráfica con título, subtítulo opcional y estado vacío.
class ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isEmpty;
  final String emptyText;
  final Widget child;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.isEmpty = false,
    this.emptyText = 'Sin datos en este período.',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: TextStyle(fontSize: 12, color: context.muted)),
              ],
              const SizedBox(height: 14),
              if (isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(emptyText, style: TextStyle(color: context.muted)),
                  ),
                )
              else
                child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Barras verticales: valor arriba y nombre abajo. La más alta va resaltada.
class VBarChart extends StatelessWidget {
  final List<({String label, double value})> items;
  final String Function(double) format;
  final Color? color;

  const VBarChart({
    super.key,
    required this.items,
    required this.format,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final base = color ?? context.brand;
    final maxValue = items.map((e) => e.value).fold<double>(0, math.max);
    const maxHeight = 120.0;
    return SizedBox(
      height: maxHeight + 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final item in items)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.value == 0 ? '' : format(item.value),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 24,
                    height: maxValue <= 0
                        ? 4
                        : math.max(4, item.value / maxValue * maxHeight),
                    decoration: BoxDecoration(
                      color: item.value == maxValue && maxValue > 0
                          ? base
                          : base.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: context.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Dos barras por grupo (por ejemplo ventas y gastos) con leyenda.
class GroupedBarChart extends StatelessWidget {
  final List<({String label, double a, double b})> groups;
  final String aName;
  final String bName;
  final Color aColor;
  final Color bColor;

  const GroupedBarChart({
    super.key,
    required this.groups,
    required this.aName,
    required this.bName,
    required this.aColor,
    required this.bColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = groups.fold<double>(0, (m, g) => math.max(m, math.max(g.a, g.b)));
    const maxHeight = 130.0;
    double h(double v) => maxValue <= 0 ? 3 : math.max(3, v / maxValue * maxHeight);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Dot(aColor), const SizedBox(width: 5), Text(aName, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 14),
            _Dot(bColor), const SizedBox(width: 5), Text(bName, style: const TextStyle(fontSize: 12)),
            const Spacer(),
            Text('Máx. \$${maxValue.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 11.5, color: context.muted)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: maxHeight + 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final g in groups)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 9,
                            height: h(g.a),
                            decoration: BoxDecoration(
                              color: aColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 9,
                            height: h(g.b),
                            decoration: BoxDecoration(
                              color: bColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(g.label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.muted,
                          )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot(this.color);

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

/// Lista de barras horizontales: nombre, barra proporcional y valor.
class HBarList extends StatelessWidget {
  final List<({String label, double value})> items;
  final String Function(double) format;
  final Color? color;

  const HBarList({
    super.key,
    required this.items,
    required this.format,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final base = color ?? context.brand;
    final maxValue = items.map((e) => e.value).fold<double>(0, math.max);
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    Text(format(item.value),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 4),
                LayoutBuilder(
                  builder: (context, box) => Stack(
                    children: [
                      Container(
                        height: 8,
                        width: box.maxWidth,
                        decoration: BoxDecoration(
                          color: base.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: maxValue <= 0 ? 0 : box.maxWidth * item.value / maxValue,
                        decoration: BoxDecoration(
                          color: base,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Gráfica de dona con leyenda y porcentaje de cada parte.
class DonutChart extends StatelessWidget {
  final List<({String label, double value})> items;
  final String Function(double) format;
  final List<Color> colors;
  final String? centerText;

  const DonutChart({
    super.key,
    required this.items,
    required this.format,
    this.colors = chartPalette,
    this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (s, e) => s + e.value);
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _DonutPainter(
              values: [for (final i in items) i.value],
              colors: colors,
              track: context.muted.withValues(alpha: .15),
            ),
            child: Center(
              child: Text(
                centerText ?? format(total),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      _Dot(colors[i % colors.length]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(items[i].label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5)),
                      ),
                      Text(
                        '${format(items[i].value)}  ·  ${total <= 0 ? 0 : (items[i].value / total * 100).round()} %',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final Color track;

  _DonutPainter({required this.values, required this.colors, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final rect = Rect.fromLTWH(
      stroke / 2, stroke / 2, size.width - stroke, size.height - stroke,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    final total = values.fold<double>(0, (s, v) => s + v);
    if (total <= 0) return;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweep = values[i] / total * math.pi * 2;
      // Un pequeño hueco entre partes mejora la lectura.
      final gap = values.where((v) => v > 0).length > 1 ? 0.03 : 0.0;
      canvas.drawArc(rect, start, math.max(0.0, sweep - gap), false,
          paint..color = colors[i % colors.length]);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.values != values || old.colors != colors || old.track != track;
}
