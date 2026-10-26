/// Documentos PDF de los reportes (gráficas y finanzas).
///
/// Usa las fuentes incluidas en el paquete `pdf`, que cubren el español
/// (tildes y ñ) pero no símbolos como la raya larga; por eso [_t] los reemplaza.
library;

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:variedadesjm/modules/finanzas/controller/finanzas_calculator.dart';
import 'package:variedadesjm/modules/reporte/controller/reporte_calculator.dart';
import 'package:variedadesjm/shared/utils/format.dart';

const _marca = PdfColor.fromInt(0xFF13315C);
const _verde = PdfColor.fromInt(0xFF1E9E6A);
const _rojo = PdfColor.fromInt(0xFFC8412F);
const _gris = PdfColor.fromInt(0xFF66758B);
const _fondo = PdfColor.fromInt(0xFFEEF2F8);

/// Reemplaza caracteres que la fuente estándar del PDF no puede dibujar.
String _t(String texto) => texto
    .replaceAll('—', '-')
    .replaceAll('–', '-')
    .replaceAll('“', '"')
    .replaceAll('”', '"')
    .replaceAll('’', "'")
    .replaceAll('≥', '>=')
    .replaceAll('\n', ' ');

pw.Widget _titulo(String texto) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16, bottom: 6),
      child: pw.Text(_t(texto),
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: _marca)),
    );

pw.Widget _encabezado(String titulo, String periodo) => pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _marca,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Variedades JM',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.white)),
          pw.SizedBox(height: 2),
          pw.Text(_t(titulo),
              style: pw.TextStyle(
                  fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
          pw.SizedBox(height: 2),
          pw.Text(_t('$periodo  |  Generado el ${shortDate(DateTime.now())}'),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ],
      ),
    );

pw.Widget _tarjeta(String etiqueta, String valor, {PdfColor color = _marca}) => pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.only(right: 8),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: _fondo,
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(_t(etiqueta), style: const pw.TextStyle(fontSize: 9, color: _gris)),
            pw.SizedBox(height: 3),
            pw.Text(_t(valor),
                style: pw.TextStyle(
                    fontSize: 15, fontWeight: pw.FontWeight.bold, color: color)),
          ],
        ),
      ),
    );

/// Tabla simple de dos o más columnas con encabezado.
pw.Widget _tabla(List<String> encabezados, List<List<String>> filas) {
  pw.Widget celda(String t, {bool negrita = false, bool derecha = false}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Text(
          _t(t),
          textAlign: derecha ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: negrita ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );
  return pw.Table(
    border: const pw.TableBorder(
      bottom: pw.BorderSide(color: PdfColors.grey300, width: .5),
      horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: .5),
    ),
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: _fondo),
        children: [
          for (var i = 0; i < encabezados.length; i++)
            celda(encabezados[i], negrita: true, derecha: i > 0),
        ],
      ),
      for (final fila in filas)
        pw.TableRow(
          children: [
            for (var i = 0; i < fila.length; i++) celda(fila[i], derecha: i > 0),
          ],
        ),
    ],
  );
}

/// Lista de barras horizontales dibujadas con contenedores.
pw.Widget _barras(List<Dato> datos, String Function(double) formato,
    {PdfColor color = _marca}) {
  if (datos.isEmpty) {
    return pw.Text('Sin datos en este periodo.',
        style: const pw.TextStyle(fontSize: 10, color: _gris));
  }
  final maximo = datos.map((d) => d.valor).reduce((a, b) => a > b ? a : b);
  const ancho = 240.0;
  return pw.Column(
    children: [
      for (final d in datos)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 3),
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: 110,
                child: pw.Text(_t(d.nombre), style: const pw.TextStyle(fontSize: 10)),
              ),
              pw.Container(
                width: maximo <= 0 ? 1 : (d.valor / maximo * ancho).clamp(1.0, ancho).toDouble(),
                height: 9,
                color: color,
              ),
              pw.SizedBox(width: 8),
              pw.Text(_t(formato(d.valor)),
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
    ],
  );
}

pw.Widget _pie() => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 18),
      child: pw.Text(
        'Generado por Variedades JM. Las cifras salen de las ventas, gastos e inventario registrados en la app.',
        style: const pw.TextStyle(fontSize: 8, color: _gris),
      ),
    );

String _pares(double v) => '${v.toStringAsFixed(0)} pares';

/// PDF de la pantalla de Gráficas.
Future<Uint8List> construirReportePdf(ReporteData d, String periodo) async {
  final doc = pw.Document(title: 'Reporte de ventas', author: 'Variedades JM');
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => [
        _encabezado('Reporte de ventas', periodo),
        pw.SizedBox(height: 12),
        pw.Row(children: [
          _tarjeta('Ingresos', money(d.ingresos), color: _verde),
          _tarjeta('Egresos', money(d.egresos), color: _rojo),
          _tarjeta('Utilidad', money(d.utilidad), color: d.utilidad < 0 ? _rojo : _marca),
          _tarjeta('Pares vendidos', '${d.paresVendidos}'),
        ]),
        _titulo('Ventas y gastos'),
        _tabla(
          ['Periodo', 'Ventas', 'Gastos', 'Diferencia'],
          [
            for (final b in d.tendencia)
              [b.etiqueta, money(b.ventas), money(b.gastos), money(b.ventas - b.gastos)],
          ],
        ),
        _titulo('Marcas mas vendidas'),
        _barras(d.marcas, _pares),
        _titulo('Modelos mas vendidos'),
        _barras(d.productos, _pares),
        _titulo('Tallas mas vendidas'),
        _barras(d.tallas, _pares),
        _titulo('Ventas por dia de la semana'),
        _barras(d.diasSemana, money, color: _verde),
        _titulo('Ventas por metodo de pago'),
        _barras(d.metodosPago, money, color: _verde),
        _titulo('Gastos por concepto'),
        _barras(d.gastosPorConcepto, money, color: _rojo),
        _titulo('Estado del inventario'),
        _tabla(
          ['Estado', 'Pares'],
          [
            ['Disponibles', '${d.stockActivo}'],
            ['Reservados', '${d.stockReservado}'],
            ['Vendidos', '${d.stockVendido}'],
            ['Sin venderse hace mas de 60 dias', '${d.stockLento} (${money(d.stockLentoValor)} al costo)'],
          ],
        ),
        _pie(),
      ],
    ),
  );
  return doc.save();
}

/// PDF de la pantalla de Finanzas: resultados, balance, flujo y razones.
Future<Uint8List> construirFinanzasPdf(FinanzasData d, String periodo) async {
  final doc = pw.Document(title: 'Reporte financiero', author: 'Variedades JM');
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => [
        _encabezado('Reporte financiero', periodo),
        pw.SizedBox(height: 12),
        pw.Row(children: [
          _tarjeta('Ganancia neta', money(d.utilidadNeta),
              color: d.utilidadNeta < 0 ? _rojo : _verde),
          _tarjeta('Ventas', money(d.ventas)),
          _tarjeta('Flujo neto', money(d.flujoNeto), color: d.flujoNeto < 0 ? _rojo : _marca),
        ]),
        _titulo('Estado de resultados'),
        _tabla(
          ['Concepto', 'Monto'],
          [
            ['Ventas', money(d.ventas)],
            ['Costo de los zapatos vendidos', '- ${money(d.costoVentas)}'],
            ['Utilidad bruta', money(d.utilidadBruta)],
            ['Gastos del negocio', '- ${money(d.gastos)}'],
            ['Utilidad neta', money(d.utilidadNeta)],
          ],
        ),
        _titulo('Balance general (a hoy)'),
        _tabla(
          ['Concepto', 'Monto'],
          [
            ['Efectivo (estimado)', money(d.efectivoEstimado)],
            ['Zapatos en bodega (al costo)', money(d.inventarioValor)],
            ['Total de lo que tienes', money(d.activoTotal)],
            ['Abonos de reservas pendientes', money(d.anticiposClientes)],
            ['Capital y ganancias acumuladas', money(d.patrimonio)],
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'El efectivo se estima con lo cobrado menos compras y gastos; la app no guarda el capital inicial.',
          style: const pw.TextStyle(fontSize: 8, color: _gris),
        ),
        _titulo('Flujo de efectivo'),
        _tabla(
          ['Concepto', 'Monto'],
          [
            ['Ventas cobradas', money(d.entradasVentas)],
            ['Abonos de reservas', money(d.entradasAbonos)],
            ['Total que entro', money(d.entradasTotal)],
            ['Compra de zapatos', '- ${money(d.salidasCompras)}'],
            ['Gastos del negocio', '- ${money(d.salidasGastos)}'],
            ['Total que salio', '- ${money(d.salidasTotal)}'],
            ['Flujo neto', money(d.flujoNeto)],
          ],
        ),
        _titulo('Razones financieras'),
        _tabla(
          ['Razon', 'Valor'],
          [for (final r in d.razones) [r.nombre, r.valor]],
        ),
        _pie(),
      ],
    ),
  );
  return doc.save();
}
