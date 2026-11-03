import 'package:flutter_test/flutter_test.dart';
import 'package:variedadesjm/modules/venta/service/venta_filtros.dart';

void main() {
  // Lunes 2 de noviembre de 2026.
  final hoy = DateTime(2026, 11, 2, 15, 30);

  test('hoy solo incluye el mismo día', () {
    expect(ventaEnRango(DateTime(2026, 11, 2, 8), VentaRango.hoy, hoy), isTrue);
    expect(ventaEnRango(DateTime(2026, 11, 1, 23, 59), VentaRango.hoy, hoy), isFalse);
  });

  test('semana corre de lunes a hoy', () {
    expect(inicioDeSemana(DateTime(2026, 11, 5)), DateTime(2026, 11, 2));
    expect(ventaEnRango(DateTime(2026, 11, 2), VentaRango.semana, hoy), isTrue);
    expect(ventaEnRango(DateTime(2026, 11, 1), VentaRango.semana, hoy), isFalse);
    // Un jueves: incluye lunes a jueves, no el domingo anterior.
    final jueves = DateTime(2026, 11, 5);
    expect(ventaEnRango(DateTime(2026, 11, 3), VentaRango.semana, jueves), isTrue);
    expect(ventaEnRango(DateTime(2026, 11, 1), VentaRango.semana, jueves), isFalse);
  });

  test('mes incluye todo el mes en curso y nada de otros meses', () {
    expect(ventaEnRango(DateTime(2026, 11, 1), VentaRango.mes, hoy), isTrue);
    expect(ventaEnRango(DateTime(2026, 10, 31), VentaRango.mes, hoy), isFalse);
    expect(ventaEnRango(DateTime(2025, 11, 2), VentaRango.mes, hoy), isFalse);
  });

  test('todas y día elegido', () {
    expect(ventaEnRango(DateTime(2020, 1, 1), VentaRango.todas, hoy), isTrue);
    expect(ventaEnDia(DateTime(2026, 10, 20, 17), DateTime(2026, 10, 20)), isTrue);
    expect(ventaEnDia(DateTime(2026, 10, 21), DateTime(2026, 10, 20)), isFalse);
  });
}
