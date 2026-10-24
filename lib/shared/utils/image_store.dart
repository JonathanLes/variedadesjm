/// Guarda las fotos de zapatos en una carpeta permanente de la app.
///
/// `image_picker` devuelve archivos en la caché temporal, que Android borra
/// cuando necesita espacio. Por eso se copian a los documentos de la app antes
/// de guardar su ruta en la base de datos.
library;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Copia [imagen] a la carpeta de documentos y devuelve la ruta permanente.
Future<String> persistShoeImage(XFile imagen) async {
  final directory = await getApplicationDocumentsDirectory();
  final extension =
      imagen.name.contains('.') ? imagen.name.split('.').last : 'jpg';
  final destino = File(
    '${directory.path}/zapato_${DateTime.now().microsecondsSinceEpoch}.$extension',
  );
  await File(imagen.path).copy(destino.path);
  return destino.path;
}
