/// Formatos de dinero y fechas en español usados por todas las pantallas.
library;

const _meses = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio',
  'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];
const _dias = [
  'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
];

/// `12.5` → `$12.50`
String money(num value) => '\$${value.toStringAsFixed(2)}';

/// `dd/MM/yyyy`
String shortDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// `Viernes 23 de octubre del 2026`
String longDate(DateTime d) =>
    '${_dias[d.weekday - 1]} ${d.day} de ${_meses[d.month - 1]} del ${d.year}';

/// `true` si ambas fechas caen en el mismo día.
bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
