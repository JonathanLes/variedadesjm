/// Cálculos financieros del negocio a partir de los registros guardados.
///
/// Es Dart puro (sin Flutter ni Riverpod) para poder probarlo con `flutter test`.
/// Supuestos, que la pantalla también explica al usuario:
///  * Todas las ventas se cobran al momento.
///  * El costo de una venta es el precio de compra del par vendido.
///  * El abono de una reserva pendiente es dinero recibido, pero todavía es una
///    obligación con el cliente (entregar el zapato o devolver el abono).
///  * No se registra capital inicial: el efectivo es una estimación.
library;

import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';

/// Ventana de tiempo que analiza la pantalla de Finanzas.
enum FinanzasPeriodo { mes, trimestre, anio }

extension FinanzasPeriodoX on FinanzasPeriodo {
  String get etiqueta => switch (this) {
        FinanzasPeriodo.mes => 'Mes',
        FinanzasPeriodo.trimestre => 'Trimestre',
        FinanzasPeriodo.anio => 'Año',
      };

  String get nombre => switch (this) {
        FinanzasPeriodo.mes => 'este mes',
        FinanzasPeriodo.trimestre => 'este trimestre',
        FinanzasPeriodo.anio => 'este año',
      };

  /// Primer día del período que contiene a [hoy].
  DateTime inicio(DateTime hoy) => switch (this) {
        FinanzasPeriodo.mes => DateTime(hoy.year, hoy.month, 1),
        FinanzasPeriodo.trimestre =>
          DateTime(hoy.year, ((hoy.month - 1) ~/ 3) * 3 + 1, 1),
        FinanzasPeriodo.anio => DateTime(hoy.year, 1, 1),
      };
}

/// Una razón financiera lista para mostrarse.
class Razon {
  final String nombre;

  /// Valor ya formateado ("42.5 %", "1.8 veces", "—").
  final String valor;

  /// Explicación en lenguaje sencillo.
  final String explicacion;

  /// `true` cuando el valor indica una situación preocupante (pérdida, etc.).
  final bool alerta;

  const Razon(this.nombre, this.valor, this.explicacion, {this.alerta = false});
}

class FinanzasData {
  final DateTime inicio;
  final DateTime fin;

  // Estado de resultados (del período).
  final double ventas;
  final double costoVentas;
  final double gastos;
  final int numeroVentas;
  final int paresVendidos;

  // Flujo de efectivo (del período).
  final double entradasVentas;
  final double entradasAbonos;
  final double salidasCompras;
  final double salidasGastos;

  // Balance general (a hoy).
  final double inventarioValor;
  final double efectivoEstimado;
  final double anticiposClientes;

  const FinanzasData({
    required this.inicio,
    required this.fin,
    required this.ventas,
    required this.costoVentas,
    required this.gastos,
    required this.numeroVentas,
    required this.paresVendidos,
    required this.entradasVentas,
    required this.entradasAbonos,
    required this.salidasCompras,
    required this.salidasGastos,
    required this.inventarioValor,
    required this.efectivoEstimado,
    required this.anticiposClientes,
  });

  double get utilidadBruta => ventas - costoVentas;
  double get utilidadNeta => utilidadBruta - gastos;

  double get entradasTotal => entradasVentas + entradasAbonos;
  double get salidasTotal => salidasCompras + salidasGastos;
  double get flujoNeto => entradasTotal - salidasTotal;

  double get activoTotal => efectivoEstimado + inventarioValor;
  double get pasivoTotal => anticiposClientes;
  double get patrimonio => activoTotal - pasivoTotal;

  int get diasDelPeriodo => fin.difference(inicio).inDays + 1;

  /// Razones financieras calculadas con los datos del período.
  List<Razon> get razones {
    String pct(double v) => '${(v * 100).toStringAsFixed(1)} %';
    final sinVentas = ventas <= 0;

    final margenBruto = sinVentas ? null : utilidadBruta / ventas;
    final margenNeto = sinVentas ? null : utilidadNeta / ventas;
    final gastoSobreVentas = sinVentas ? null : gastos / ventas;
    final ticket = numeroVentas == 0 ? null : ventas / numeroVentas;
    final rendimiento = costoVentas <= 0 ? null : utilidadBruta / costoVentas;
    final rotacion = inventarioValor <= 0 ? null : costoVentas / inventarioValor;
    final diasInventario =
        (rotacion == null || rotacion <= 0) ? null : diasDelPeriodo / rotacion;
    final razonCorriente =
        anticiposClientes <= 0 ? null : activoTotal / anticiposClientes;
    final puntoEquilibrio = (margenBruto == null || margenBruto <= 0)
        ? null
        : gastos / margenBruto;

    return [
      Razon(
        'Margen bruto',
        margenBruto == null ? '—' : pct(margenBruto),
        'De cada \$100 que vendes, esto es lo que queda después de pagar el costo de los zapatos.',
        alerta: margenBruto != null && margenBruto < 0,
      ),
      Razon(
        'Margen neto',
        margenNeto == null ? '—' : pct(margenNeto),
        'De cada \$100 que vendes, esto es lo que realmente ganas después de gastos.',
        alerta: margenNeto != null && margenNeto < 0,
      ),
      Razon(
        'Gastos sobre ventas',
        gastoSobreVentas == null ? '—' : pct(gastoSobreVentas),
        'Qué parte de tus ventas se va en gastos del negocio. Mientras menor, mejor.',
      ),
      Razon(
        'Rendimiento de la inversión',
        rendimiento == null ? '—' : '${(rendimiento * 100).toStringAsFixed(1)} %',
        'Por cada \$1 invertido en los zapatos que vendiste, cuánto ganaste además de recuperarlo.',
        alerta: rendimiento != null && rendimiento < 0,
      ),
      Razon(
        'Rotación de inventario',
        rotacion == null ? '—' : '${rotacion.toStringAsFixed(2)} veces',
        'Cuántas veces vendiste el equivalente a tu inventario actual en este período.',
      ),
      Razon(
        'Días de inventario',
        diasInventario == null ? '—' : '${diasInventario.toStringAsFixed(0)} días',
        'Cuántos días tardarías en vender lo que tienes en bodega al ritmo actual.',
      ),
      Razon(
        'Razón corriente',
        razonCorriente == null
            ? 'Sin deudas'
            : '${razonCorriente.toStringAsFixed(2)} veces',
        'Cuánto tienes (efectivo e inventario) por cada \$1 que debes a clientes por abonos.',
        alerta: razonCorriente != null && razonCorriente < 1,
      ),
      Razon(
        'Ticket promedio',
        ticket == null ? '—' : '\$${ticket.toStringAsFixed(2)}',
        'Lo que gasta en promedio un cliente en cada venta.',
      ),
      Razon(
        'Punto de equilibrio',
        puntoEquilibrio == null ? '—' : '\$${puntoEquilibrio.toStringAsFixed(2)}',
        'Cuánto necesitas vender en el período para cubrir tus gastos sin perder dinero.',
      ),
    ];
  }
}

bool _enRango(DateTime fecha, DateTime inicio, DateTime fin) {
  final dia = DateTime(fecha.year, fecha.month, fecha.day);
  return !dia.isBefore(inicio) && !dia.isAfter(fin);
}

/// Calcula todos los indicadores para el período indicado.
FinanzasData calcularFinanzas({
  required DateTime inicio,
  required DateTime fin,
  required List<Venta> ventas,
  required List<VentaDetalle> detalles,
  required List<Gasto> gastos,
  required List<Inventario> inventario,
  required List<Reserva> reservas,
}) {
  final ventasPeriodo = ventas.where((v) => _enRango(v.fechaVenta, inicio, fin)).toList();
  final idsVentas = ventasPeriodo.map((v) => v.id).toSet();
  final gastosPeriodo = gastos.where((g) => _enRango(g.fechaGasto, inicio, fin)).toList();
  final inventarioPorId = <String, Inventario>{for (final i in inventario) i.id: i};

  var costo = 0.0;
  var pares = 0;
  for (final d in detalles) {
    if (!idsVentas.contains(d.idVenta)) continue;
    pares++;
    costo += inventarioPorId[d.idInventario]?.precioCompra ?? 0;
  }

  final totalVentas = ventasPeriodo.fold<double>(0, (s, v) => s + v.total);
  final totalGastos = gastosPeriodo.fold<double>(0, (s, g) => s + g.monto);

  // Abonos de reservas pendientes: dinero recibido que aún se debe al cliente.
  final pendientes = reservas.where((r) => r.estado == ReservaEstado.pendiente).toList();
  final abonosPeriodo = pendientes
      .where((r) => _enRango(r.fechaReserva, inicio, fin))
      .fold<double>(0, (s, r) => s + r.adelanto);
  final anticipos = pendientes.fold<double>(0, (s, r) => s + r.adelanto);

  final comprasPeriodo = inventario
      .where((i) => _enRango(i.fechaCompra, inicio, fin))
      .fold<double>(0, (s, i) => s + i.precioCompra);

  // Balance: valor de lo que sigue en bodega (disponible o apartado), al costo.
  final inventarioValor = inventario
      .where((i) => i.estado != EstadoZapato.vendido)
      .fold<double>(0, (s, i) => s + i.precioCompra);

  // Efectivo estimado acumulado: lo cobrado menos lo pagado desde el inicio.
  final efectivo = ventas.fold<double>(0, (s, v) => s + v.total) +
      anticipos -
      inventario.fold<double>(0, (s, i) => s + i.precioCompra) -
      gastos.fold<double>(0, (s, g) => s + g.monto);

  return FinanzasData(
    inicio: inicio,
    fin: fin,
    ventas: totalVentas,
    costoVentas: costo,
    gastos: totalGastos,
    numeroVentas: ventasPeriodo.length,
    paresVendidos: pares,
    entradasVentas: totalVentas,
    entradasAbonos: abonosPeriodo,
    salidasCompras: comprasPeriodo,
    salidasGastos: totalGastos,
    inventarioValor: inventarioValor,
    efectivoEstimado: efectivo,
    anticiposClientes: anticipos,
  );
}
