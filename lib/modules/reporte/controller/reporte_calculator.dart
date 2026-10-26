/// Indicadores y series de las gráficas del negocio.
///
/// Dart puro (sin Flutter) para poder probarlo con `flutter test` y reutilizarlo
/// tanto en la pantalla de Gráficas como en el PDF.
library;

import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';

enum ReportePeriodo { semana, mes, anio }

extension ReportePeriodoX on ReportePeriodo {
  String get etiqueta => switch (this) {
        ReportePeriodo.semana => 'Semana',
        ReportePeriodo.mes => 'Mes',
        ReportePeriodo.anio => 'Año',
      };

  String get nombre => switch (this) {
        ReportePeriodo.semana => 'últimos 7 días',
        ReportePeriodo.mes => 'este mes',
        ReportePeriodo.anio => 'este año',
      };

  DateTime inicio(DateTime hoy) => switch (this) {
        ReportePeriodo.semana => DateTime(hoy.year, hoy.month, hoy.day - 6),
        ReportePeriodo.mes => DateTime(hoy.year, hoy.month, 1),
        ReportePeriodo.anio => DateTime(hoy.year, 1, 1),
      };
}

/// Un grupo de la gráfica "Ventas vs gastos".
class Barra {
  final String etiqueta;
  final double ventas;
  final double gastos;

  const Barra(this.etiqueta, this.ventas, this.gastos);
}

/// Un valor con nombre (marca, talla, método de pago...).
class Dato {
  final String nombre;
  final double valor;

  const Dato(this.nombre, this.valor);
}

class ReporteData {
  final DateTime inicio;
  final DateTime fin;
  final double ingresos;
  final double egresos;
  final int numeroVentas;
  final int paresVendidos;
  final List<Barra> tendencia;
  final List<Dato> marcas;
  final List<Dato> productos;
  final List<Dato> tallas;

  /// Ventas en dinero por día de la semana, de lunes (0) a domingo (6).
  final List<Dato> diasSemana;
  final List<Dato> metodosPago;
  final List<Dato> gastosPorConcepto;
  final int stockActivo;
  final int stockReservado;
  final int stockVendido;
  final int stockLento;
  final double stockLentoValor;
  final Dato? mejorDia;

  const ReporteData({
    required this.inicio,
    required this.fin,
    required this.ingresos,
    required this.egresos,
    required this.numeroVentas,
    required this.paresVendidos,
    required this.tendencia,
    required this.marcas,
    required this.productos,
    required this.tallas,
    required this.diasSemana,
    required this.metodosPago,
    required this.gastosPorConcepto,
    required this.stockActivo,
    required this.stockReservado,
    required this.stockVendido,
    required this.stockLento,
    required this.stockLentoValor,
    required this.mejorDia,
  });

  double get utilidad => ingresos - egresos;
  bool get sinVentas => numeroVentas == 0;
}

const _dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
const _diasLargos = [
  'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
];
const _meses = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
];

DateTime _dia(DateTime d) => DateTime(d.year, d.month, d.day);

String _capitalizar(String texto) {
  final t = texto.trim();
  if (t.isEmpty) return t;
  return t[0].toUpperCase() + t.substring(1).toLowerCase();
}

String _etiquetaTalla(double talla) =>
    talla == talla.roundToDouble() ? '${talla.toInt()}' : talla.toString();

/// Suma por nombre, ordena de mayor a menor y devuelve los [limite] primeros.
List<Dato> _ranking(Map<String, double> mapa, int limite) {
  final lista = mapa.entries.map((e) => Dato(e.key, e.value)).toList()
    ..sort((a, b) => b.valor.compareTo(a.valor));
  return lista.take(limite).toList();
}

ReporteData calcularReporte({
  required DateTime hoy,
  required ReportePeriodo periodo,
  required List<Venta> ventas,
  required List<VentaDetalle> detalles,
  required List<Gasto> gastos,
  required List<Inventario> inventario,
  required List<Zapato> zapatos,
  required List<Marca> marcas,
}) {
  final fin = _dia(hoy);
  final inicio = periodo.inicio(hoy);
  bool enRango(DateTime f) {
    final d = _dia(f);
    return !d.isBefore(inicio) && !d.isAfter(fin);
  }

  final ventasP = ventas.where((v) => enRango(v.fechaVenta)).toList();
  final gastosP = gastos.where((g) => enRango(g.fechaGasto)).toList();
  final idsVentas = ventasP.map((v) => v.id).toSet();
  final ingresos = ventasP.fold<double>(0, (s, v) => s + v.total);
  final egresos = gastosP.fold<double>(0, (s, g) => s + g.monto);

  // ---- Tendencia: ventas vs gastos por día, semana del mes o mes.
  late final int grupos;
  late final int Function(DateTime) indice;
  late final String Function(int) etiqueta;
  switch (periodo) {
    case ReportePeriodo.semana:
      grupos = 7;
      indice = (f) => _dia(f).difference(inicio).inDays;
      etiqueta = (i) => _dias[_dia(inicio.add(Duration(days: i))).weekday - 1];
    case ReportePeriodo.mes:
      grupos = ((fin.day - 1) ~/ 7) + 1;
      indice = (f) => (f.day - 1) ~/ 7;
      etiqueta = (i) => 'Sem ${i + 1}';
    case ReportePeriodo.anio:
      grupos = fin.month;
      indice = (f) => f.month - 1;
      etiqueta = (i) => _meses[i];
  }
  final sumaVentas = List<double>.filled(grupos, 0);
  final sumaGastos = List<double>.filled(grupos, 0);
  for (final v in ventasP) {
    final i = indice(v.fechaVenta);
    if (i >= 0 && i < grupos) sumaVentas[i] += v.total;
  }
  for (final g in gastosP) {
    final i = indice(g.fechaGasto);
    if (i >= 0 && i < grupos) sumaGastos[i] += g.monto;
  }
  final tendencia = [
    for (var i = 0; i < grupos; i++) Barra(etiqueta(i), sumaVentas[i], sumaGastos[i]),
  ];

  // ---- Pares vendidos: marca, producto y talla.
  final porInventario = <String, Inventario>{for (final i in inventario) i.id: i};
  final porZapato = <String, Zapato>{for (final z in zapatos) z.id: z};
  final nombreMarca = <String, String>{for (final m in marcas) m.id: m.nombreMarca};
  final porMarca = <String, double>{};
  final porProducto = <String, double>{};
  final porTalla = <String, double>{};
  var pares = 0;
  for (final d in detalles) {
    if (!idsVentas.contains(d.idVenta)) continue;
    pares++;
    final par = porInventario[d.idInventario];
    final modelo = par == null ? null : porZapato[par.idZapato];
    final marca = (modelo == null ? null : nombreMarca[modelo.idMarca]) ?? 'Sin marca';
    porMarca[marca] = (porMarca[marca] ?? 0) + 1;
    final producto = modelo?.modelo ?? 'Sin modelo';
    porProducto[producto] = (porProducto[producto] ?? 0) + 1;
    if (par != null) {
      final t = _etiquetaTalla(par.talla);
      porTalla[t] = (porTalla[t] ?? 0) + 1;
    }
  }

  // ---- Ventas por día de la semana y método de pago.
  final porDia = List<double>.filled(7, 0);
  final porMetodo = <String, double>{};
  for (final v in ventasP) {
    porDia[v.fechaVenta.weekday - 1] += v.total;
    final metodo = v.metodoPago.trim().isEmpty ? 'Sin dato' : _capitalizar(v.metodoPago);
    porMetodo[metodo] = (porMetodo[metodo] ?? 0) + v.total;
  }
  Dato? mejorDia;
  for (var i = 0; i < 7; i++) {
    if (porDia[i] > 0 && (mejorDia == null || porDia[i] > mejorDia.valor)) {
      mejorDia = Dato(_diasLargos[i], porDia[i]);
    }
  }

  // ---- Gastos por concepto (los 5 mayores y el resto como "Otros").
  final porConcepto = <String, double>{};
  for (final g in gastosP) {
    final c = g.descripcion.trim().isEmpty ? 'Sin concepto' : _capitalizar(g.descripcion);
    porConcepto[c] = (porConcepto[c] ?? 0) + g.monto;
  }
  final conceptos = _ranking(porConcepto, porConcepto.length);
  final gastosConcepto = conceptos.length <= 5
      ? conceptos
      : [
          ...conceptos.take(5),
          Dato('Otros', conceptos.skip(5).fold<double>(0, (s, d) => s + d.valor)),
        ];

  // ---- Inventario: estado y "stock lento" (más de 60 días sin venderse).
  final limiteLento = fin.subtract(const Duration(days: 60));
  final lentos = inventario.where(
    (i) => i.estado == EstadoZapato.activo && _dia(i.fechaCompra).isBefore(limiteLento),
  );

  return ReporteData(
    inicio: inicio,
    fin: fin,
    ingresos: ingresos,
    egresos: egresos,
    numeroVentas: ventasP.length,
    paresVendidos: pares,
    tendencia: tendencia,
    marcas: _ranking(porMarca, 5),
    productos: _ranking(porProducto, 5),
    tallas: _ranking(porTalla, 6),
    diasSemana: [for (var i = 0; i < 7; i++) Dato(_dias[i], porDia[i])],
    metodosPago: _ranking(porMetodo, 6),
    gastosPorConcepto: gastosConcepto,
    stockActivo: inventario.where((i) => i.estado == EstadoZapato.activo).length,
    stockReservado: inventario.where((i) => i.estado == EstadoZapato.reservado).length,
    stockVendido: inventario.where((i) => i.estado == EstadoZapato.vendido).length,
    stockLento: lentos.length,
    stockLentoValor: lentos.fold<double>(0, (s, i) => s + i.precioCompra),
    mejorDia: mejorDia,
  );
}
