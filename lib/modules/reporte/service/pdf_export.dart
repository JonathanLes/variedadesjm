/// Entrega un PDF al usuario: guardar/imprimir o compartir.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Construye el PDF con [construir] y ofrece guardarlo o compartirlo.
///
/// "Guardar o imprimir" abre el diálogo del sistema, que incluye
/// "Guardar como PDF". "Compartir" abre la hoja para enviarlo por WhatsApp,
/// correo o guardarlo en Drive.
Future<void> exportarPdf(
  BuildContext context, {
  required String titulo,
  required String archivo,
  required Future<Uint8List> Function() construir,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  Uint8List bytes;
  try {
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Preparando el PDF...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    bytes = await construir();
  } catch (error) {
    debugPrint('PDF: error al construir: $error');
    messenger.showSnackBar(
      const SnackBar(
        content: Text('No se pudo crear el PDF.'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Tu reporte está listo.',
                style: TextStyle(fontSize: 13, color: sheetContext.muted)),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () async {
                Navigator.pop(sheetContext);
                await Printing.layoutPdf(onLayout: (_) async => bytes, name: archivo);
              },
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Guardar o imprimir'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(sheetContext);
                await Printing.sharePdf(bytes: bytes, filename: archivo);
              },
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.share_outlined),
              label: const Text('Compartir'),
            ),
          ],
        ),
      ),
    ),
  );
}
