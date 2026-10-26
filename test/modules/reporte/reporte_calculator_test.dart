import 'package:flutter_test/flutter_test.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/marca/entity/marca.dart';
import 'package:variedadesjm/modules/reporte/controller/reporte_calculator.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';
import 'package:variedadesjm/modules/zapato/entity/zapato.dart';

Inventario _par(String id, String zapato, double talla, double costo, DateTime compra,
        EstadoZapato estado) =>
    Inventario(
      id: id,
      idZapato: zapato,
      codigo: id,
      talla: talla,
      cm: 26,
      precioCompra: costo,
      fechaCompra: compra,
      estado: estado,
    );

Gasto _gasto(String id, String concepto, double monto, DateTime fecha) => Gasto(
      id: id,
      descripcion: concepto,
      monto: monto,
      fechaGasto: fecha,
      idCategoriaGasto: 'x',
      metodoPago: 'efectivo',
    );

void main() {
  // Sábado 24 de octubre de 2026.
  final hoy = DateTime(2026, 10, 24);

  ReporteData calcular(ReportePeriodo periodo) => calcularReporte(
        hoy: hoy,
        periodo: periodo,
        ventas: [
          Venta(id: 'v1', idCliente: 'c', fechaVenta: DateTime(2026, 10, 3), metodoPago: 'efectivo', total: 50),
          Venta(id: 'v2', idCliente: 'c', fechaVenta: DateTime(2026, 10, 5), metodoPago: 'transferencia', total: 70),
          Venta(id: 'v3', idCliente: 'c', fechaVenta: DateTime(2026, 9, 20), metodoPago: 'efectivo', total: 99),
        ],
        detalles: const [
          VentaDetalle(id: 'd1', idVenta: 'v1', idInventario: 'i1', precioVentaFinal: 50),
          VentaDetalle(id: 'd2', idVenta: 'v2', idInventario: 'i2', precioVentaFinal: 70),
        ],
        gastos: [
          _gasto('g1', 'comida', 15, DateTime(2026, 10, 4)),
          _gasto('g2', 'COMIDA', 5, DateTime(2026, 10, 6)),
          _gasto('g3', 'uber', 8, DateTime(2026, 10, 7)),
        ],
        inventario: [
          _par('i1', 'z1', 9, 20, DateTime(2026, 10, 2), EstadoZapato.vendido),
          _par('i2', 'z2', 8, 30, DateTime(2026, 10, 3), EstadoZapato.vendido),
          _par('i3', 'z1', 9, 40, DateTime(2026, 7, 1), EstadoZapato.activo),
          _par('i4', 'z2', 10, 10, DateTime(2026, 10, 10), EstadoZapato.reservado),
        ],
        zapatos: const [
          Zapato(id: 'z1', modelo: 'Air Force', idMarca: 'm1', idCategoria: 'c', precioVentaSugerido: 50),
          Zapato(id: 'z2', modelo: 'Samba', idMarca: 'm2', idCategoria: 'c', precioVentaSugerido: 70),
        ],
        marcas: const [
          Marca(id: 'm1', nombreMarca: 'Nike'),
          Marca(id: 'm2', nombreMarca: 'Adidas'),
        ],
      );

  test('resume ingresos, egresos y pares del mes', () {
    final d = calcular(ReportePeriodo.mes);
    expect(d.ingresos, 120);
    expect(d.egresos, 28);
    expect(d.utilidad, 92);
    expect(d.numeroVentas, 2);
    expect(d.paresVendidos, 2);
  });

  test('agrupa ventas y gastos por semana del mes', () {
    final d = calcular(ReportePeriodo.mes);
    expect(d.tendencia.length, 4); // el día 24 cae en la semana 4
    expect(d.tendencia.first.ventas, 120);
    expect(d.tendencia.first.gastos, 28);
    expect(d.tendencia[1].ventas, 0);
  });

  test('rankings por marca, talla, método de pago y concepto', () {
    final d = calcular(ReportePeriodo.mes);
    expect({for (final m in d.marcas) m.nombre: m.valor}, {'Nike': 1, 'Adidas': 1});
    expect({for (final t in d.tallas) t.nombre: t.valor}, {'9': 1, '8': 1});
    expect({for (final m in d.metodosPago) m.nombre: m.valor},
        {'Efectivo': 50, 'Transferencia': 70});
    expect(d.gastosPorConcepto.first.nombre, 'Comida');
    expect(d.gastosPorConcepto.first.valor, 20);
  });

  test('mejor día de la semana y estado del inventario', () {
    final d = calcular(ReportePeriodo.mes);
    expect(d.mejorDia?.nombre, 'Lunes');
    expect(d.mejorDia?.valor, 70);
    expect(d.stockActivo, 1);
    expect(d.stockReservado, 1);
    expect(d.stockVendido, 2);
    expect(d.stockLento, 1);
    expect(d.stockLentoValor, 40);
  });

  test('el año incluye ventas de meses anteriores', () {
    final d = calcular(ReportePeriodo.anio);
    expect(d.ingresos, 219); // 50 + 70 + 99
    expect(d.tendencia.length, 10); // enero a octubre
  });
}
