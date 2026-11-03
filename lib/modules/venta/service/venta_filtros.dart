/// Reglas para filtrar ventas por fecha (pastillas Hoy / Semana / Mes y día elegido).
library;

enum VentaRango {
  hoy('Hoy'),
  semana('Semana'),
  mes('Mes'),
  todas('Todas');

  const VentaRango(this.etiqueta);
  final String etiqueta;
}

DateTime _soloDia(DateTime d) => DateTime(d.year, d.month, d.day);

/// Lunes de la semana de [d] (la semana corre de lunes a domingo).
DateTime inicioDeSemana(DateTime d) => _soloDia(d).subtract(Duration(days: d.weekday - 1));

/// `true` si [fecha] cae en [rango], contando desde [hoy].
/// "Semana" es la semana en curso (desde el lunes) y "Mes" el mes en curso.
bool ventaEnRango(DateTime fecha, VentaRango rango, DateTime hoy) {
  final dia = _soloDia(fecha);
  final hoyDia = _soloDia(hoy);
  switch (rango) {
    case VentaRango.todas:
      return true;
    case VentaRango.hoy:
      return dia == hoyDia;
    case VentaRango.semana:
      return !dia.isBefore(inicioDeSemana(hoyDia)) && !dia.isAfter(hoyDia);
    case VentaRango.mes:
      return dia.year == hoyDia.year && dia.month == hoyDia.month && !dia.isAfter(hoyDia);
  }
}

/// `true` si [fecha] cae exactamente en el día [dia].
bool ventaEnDia(DateTime fecha, DateTime dia) => _soloDia(fecha) == _soloDia(dia);
