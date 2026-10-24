import 'package:flutter_test/flutter_test.dart';
import 'package:variedadesjm/modules/finanzas/controller/finanzas_calculator.dart';
import 'package:variedadesjm/modules/gasto/entity/gasto.dart';
import 'package:variedadesjm/modules/inventario/entity/inventario.dart';
import 'package:variedadesjm/modules/reserva/entity/reserva.dart';
import 'package:variedadesjm/modules/venta/entity/venta.dart';
import 'package:variedadesjm/modules/venta_detalle/entity/venta_detalle.dart';

Inventario _par(String id, double costo, DateTime compra, EstadoZapato estado) =>
    Inventario(
      id: id,
      idZapato: 'z',
      codigo: id,
      talla: 8,
      cm: 26,
      precioCompra: costo,
      fechaCompra: compra,
      estado: estado,
    );

void main() {
  test('calcula resultados, flujo, balance y razones del período', () {
    final data = calcularFinanzas(
      inicio: DateTime(2026, 10, 1),
      fin: DateTime(2026, 10, 24),
      ventas: [
        Venta(id: 'v1', idCliente: 'c', fechaVenta: DateTime(2026, 10, 3), metodoPago: 'efectivo', total: 50),
        Venta(id: 'v2', idCliente: 'c', fechaVenta: DateTime(2026, 9, 20), metodoPago: 'efectivo', total: 60),
      ],
      detalles: const [
        VentaDetalle(id: 'd1', idVenta: 'v1', idInventario: 'i1', precioVentaFinal: 50),
        VentaDetalle(id: 'd2', idVenta: 'v2', idInventario: 'i2', precioVentaFinal: 60),
      ],
      gastos: [
        Gasto(id: 'g1', descripcion: 'Comida', monto: 15, fechaGasto: DateTime(2026, 10, 4), idCategoriaGasto: 'x', metodoPago: 'efectivo'),
        Gasto(id: 'g2', descripcion: 'Uber', monto: 5, fechaGasto: DateTime(2026, 9, 10), idCategoriaGasto: 'x', metodoPago: 'efectivo'),
      ],
      inventario: [
        _par('i1', 20, DateTime(2026, 10, 2), EstadoZapato.vendido),
        _par('i2', 30, DateTime(2026, 9, 15), EstadoZapato.vendido),
        _par('i3', 40, DateTime(2026, 10, 5), EstadoZapato.activo),
        _par('i4', 10, DateTime(2026, 10, 10), EstadoZapato.reservado),
      ],
      reservas: [
        Reserva(id: 'r1', idCliente: 'c', fechaReserva: DateTime(2026, 10, 10), fechaVencimiento: DateTime(2026, 10, 30), adelanto: 5, estado: ReservaEstado.pendiente),
        Reserva(id: 'r2', idCliente: 'c', fechaReserva: DateTime(2026, 10, 11), fechaVencimiento: DateTime(2026, 10, 30), adelanto: 7, estado: ReservaEstado.cancelado),
      ],
    );

    // Resultados
    expect(data.ventas, 50);
    expect(data.costoVentas, 20);
    expect(data.utilidadBruta, 30);
    expect(data.gastos, 15);
    expect(data.utilidadNeta, 15);
    expect(data.paresVendidos, 1);
    // Flujo
    expect(data.entradasTotal, 55);
    expect(data.salidasCompras, 70);
    expect(data.flujoNeto, -30);
    // Balance
    expect(data.inventarioValor, 50);
    expect(data.anticiposClientes, 5);
    expect(data.efectivoEstimado, -5);
    expect(data.patrimonio, 40);
    // Razones
    final razones = {for (final r in data.razones) r.nombre: r.valor};
    expect(razones['Margen bruto'], '60.0 %');
    expect(razones['Ticket promedio'], '\$50.00');
    expect(razones['Punto de equilibrio'], '\$25.00');
    expect(razones['Razón corriente'], '9.00 veces');
  });

  test('sin ventas las razones muestran guion y no fallan', () {
    final data = calcularFinanzas(
      inicio: DateTime(2026, 10, 1),
      fin: DateTime(2026, 10, 24),
      ventas: const [],
      detalles: const [],
      gastos: const [],
      inventario: const [],
      reservas: const [],
    );
    expect(data.utilidadNeta, 0);
    expect({for (final r in data.razones) r.nombre: r.valor}['Margen bruto'], '—');
  });
}
