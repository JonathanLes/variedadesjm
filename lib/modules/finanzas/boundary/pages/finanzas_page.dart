/// Finanzas: estado de resultados, balance general, flujo de efectivo y razones.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/finanzas/controller/finanzas_calculator.dart';
import 'package:variedadesjm/modules/reporte/service/pdf_export.dart';
import 'package:variedadesjm/modules/reporte/service/reporte_pdf.dart';
import 'package:variedadesjm/shared/data/app_data_provider.dart';
import 'package:variedadesjm/shared/themes/colors.dart';
import 'package:variedadesjm/shared/utils/format.dart';
import 'package:variedadesjm/shared/widgets/ui/pill_selector.dart';

enum _Vista { resultados, balance, flujo, razones }

extension on _Vista {
  String get etiqueta => switch (this) {
        _Vista.resultados => 'Resultados',
        _Vista.balance => 'Balance',
        _Vista.flujo => 'Flujo de efectivo',
        _Vista.razones => 'Razones',
      };
}

class FinanzasPage extends ConsumerStatefulWidget {
  const FinanzasPage({super.key});

  @override
  ConsumerState<FinanzasPage> createState() => _FinanzasPageState();
}

class _FinanzasPageState extends ConsumerState<FinanzasPage> {
  FinanzasPeriodo _periodo = FinanzasPeriodo.mes;
  _Vista _vista = _Vista.resultados;
  FinanzasData? _ultima;

  @override
  Widget build(BuildContext context) {
    final ventas = ref.watch(ventasProvider);
    final detalles = ref.watch(ventaDetallesProvider);
    final gastos = ref.watch(gastosProvider);
    final stock = ref.watch(existenciasProvider);
    final reservas = ref.watch(reservasProvider);
    final todos = [ventas, detalles, gastos, stock, reservas];

    Widget body;
    final error = todos.where((v) => v.hasError).toList();
    if (error.isNotEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No se pudieron cargar las finanzas: ${error.first.error}'),
        ),
      );
    } else if (!todos.every((v) => v.hasValue)) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      try {
        final hoy = DateTime.now();
        final data = calcularFinanzas(
          inicio: _periodo.inicio(hoy),
          fin: DateTime(hoy.year, hoy.month, hoy.day),
          ventas: ventas.requireValue,
          detalles: detalles.requireValue,
          gastos: gastos.requireValue,
          inventario: stock.requireValue,
          reservas: reservas.requireValue,
        );
        _ultima = data;
        body = _contenido(context, data);
      } catch (error, stack) {
        debugPrint('Finanzas: error al calcular: $error\n$stack');
        body = Center(child: Text('No se pudo calcular: $error'));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanzas'),
        actions: [
          IconButton(
            tooltip: 'Descargar PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _ultima == null
                ? null
                : () {
                    final data = _ultima!;
                    exportarPdf(
                      context,
                      titulo: 'Reporte financiero - ${_periodo.nombre}',
                      archivo: 'finanzas_${_periodo.name}.pdf',
                      construir: () => construirFinanzasPdf(data, _periodo.nombre),
                    );
                  },
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _contenido(BuildContext context, FinanzasData d) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        const Text('Cómo va tu negocio, explicado sin tecnicismos.'),
        const SizedBox(height: 12),
        PillSelector<FinanzasPeriodo>(
          values: FinanzasPeriodo.values,
          labels: [for (final p in FinanzasPeriodo.values) p.etiqueta],
          selected: _periodo,
          onChanged: (p) => setState(() => _periodo = p),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final v in _Vista.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(v.etiqueta),
                    selected: _vista == v,
                    onSelected: (_) => setState(() => _vista = v),
                    selectedColor: scheme.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _vista == v ? Colors.white : scheme.onSurface,
                    ),
                    showCheckmark: false,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        switch (_vista) {
          _Vista.resultados => _resultados(context, d),
          _Vista.balance => _balance(context, d),
          _Vista.flujo => _flujo(context, d),
          _Vista.razones => _razones(context, d),
        },
      ],
    );
  }

  // ------------------------------------------------------------ Resultados
  Widget _resultados(BuildContext context, FinanzasData d) {
    final ganancia = d.utilidadNeta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Hero(
          titulo: 'Ganancia neta · ${_periodo.nombre}',
          valor: money(ganancia),
          pie: '${d.numeroVentas} ventas · ${d.paresVendidos} pares vendidos',
          alerta: ganancia < 0,
        ),
        const SizedBox(height: 12),
        _Tabla(filas: [
          _Fila('Ventas', money(d.ventas)),
          _Fila('Costo de los zapatos vendidos', '- ${money(d.costoVentas)}',
              color: AppColors.danger),
          _Fila('Utilidad bruta', money(d.utilidadBruta), negrita: true),
          _Fila('Gastos del negocio', '- ${money(d.gastos)}', color: AppColors.danger),
          _Fila('Utilidad neta', money(d.utilidadNeta),
              negrita: true,
              color: d.utilidadNeta < 0 ? AppColors.danger : AppColors.success),
        ]),
        const _Nota(
          'Estado de resultados. El costo es lo que pagaste por cada par que vendiste en el período.',
        ),
      ],
    );
  }

  // --------------------------------------------------------------- Balance
  Widget _balance(BuildContext context, FinanzasData d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Hero(
          titulo: 'Valor del negocio hoy',
          valor: money(d.patrimonio),
          pie: 'Lo que tienes menos lo que debes',
          alerta: d.patrimonio < 0,
        ),
        const SizedBox(height: 12),
        const _Subtitulo('Lo que tienes'),
        _Tabla(filas: [
          _Fila('Efectivo (estimado)', money(d.efectivoEstimado),
              color: d.efectivoEstimado < 0 ? AppColors.danger : null),
          _Fila('Zapatos en bodega (al costo)', money(d.inventarioValor)),
          _Fila('Total de lo que tienes', money(d.activoTotal), negrita: true),
        ]),
        const _Subtitulo('Lo que debes'),
        _Tabla(filas: [
          _Fila('Abonos de reservas pendientes', money(d.anticiposClientes)),
          _Fila('Total de lo que debes', money(d.pasivoTotal), negrita: true),
        ]),
        const _Subtitulo('Lo que es tuyo'),
        _Tabla(filas: [
          _Fila('Capital y ganancias acumuladas', money(d.patrimonio), negrita: true),
        ]),
        const _Nota(
          'Balance general simplificado. El efectivo se estima con lo cobrado menos lo pagado en compras y gastos desde el inicio. '
          'Como la app no guarda el capital con el que empezaste, esa cifra puede diferir de tu caja real.',
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- Flujo
  Widget _flujo(BuildContext context, FinanzasData d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Hero(
          titulo: 'Flujo neto · ${_periodo.nombre}',
          valor: money(d.flujoNeto),
          pie: d.flujoNeto >= 0
              ? 'Entró más dinero del que salió'
              : 'Salió más dinero del que entró',
          alerta: d.flujoNeto < 0,
        ),
        const SizedBox(height: 12),
        const _Subtitulo('Entradas de dinero'),
        _Tabla(filas: [
          _Fila('Ventas cobradas', money(d.entradasVentas)),
          _Fila('Abonos de reservas', money(d.entradasAbonos)),
          _Fila('Total que entró', money(d.entradasTotal),
              negrita: true, color: AppColors.success),
        ]),
        const _Subtitulo('Salidas de dinero'),
        _Tabla(filas: [
          _Fila('Compra de zapatos', '- ${money(d.salidasCompras)}'),
          _Fila('Gastos del negocio', '- ${money(d.salidasGastos)}'),
          _Fila('Total que salió', '- ${money(d.salidasTotal)}',
              negrita: true, color: AppColors.danger),
        ]),
        const _Nota(
          'Flujo de efectivo. Aquí cuenta cuándo se mueve el dinero: una compra grande de zapatos puede dejar el flujo en negativo aunque el negocio gane.',
        ),
      ],
    );
  }

  // --------------------------------------------------------------- Razones
  Widget _razones(BuildContext context, FinanzasData d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Razones financieras · ${_periodo.nombre}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        for (final r in d.razones) _RazonCard(razon: r),
      ],
    );
  }
}

// =================================================================== widgets
class _Hero extends StatelessWidget {
  final String titulo;
  final String valor;
  final String pie;
  final bool alerta;

  const _Hero({
    required this.titulo,
    required this.valor,
    required this.pie,
    this.alerta = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: alerta ? AppColors.danger : scheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(valor,
              style: const TextStyle(
                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(pie, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
        ],
      ),
    );
  }
}

class _Fila {
  final String etiqueta;
  final String valor;
  final bool negrita;
  final Color? color;

  const _Fila(this.etiqueta, this.valor, {this.negrita = false, this.color});
}

class _Tabla extends StatelessWidget {
  final List<_Fila> filas;

  const _Tabla({required this.filas});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          children: [
            for (var i = 0; i < filas.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        filas[i].etiqueta,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              filas[i].negrita ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      filas[i].valor,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight:
                            filas[i].negrita ? FontWeight.w800 : FontWeight.w700,
                        color: filas[i].color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Subtitulo extends StatelessWidget {
  final String texto;

  const _Subtitulo(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(texto,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      );
}

class _Nota extends StatelessWidget {
  final String texto;

  const _Nota(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
}

class _RazonCard extends StatelessWidget {
  final Razon razon;

  const _RazonCard({required this.razon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(razon.nombre,
                        style: const TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w800)),
                  ),
                  Text(
                    razon.valor,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: razon.alerta
                          ? AppColors.danger
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                razon.explicacion,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
