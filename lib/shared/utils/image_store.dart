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


const _prefijoFoto = 'zapato_';

/// Nombre de archivo (sin carpetas) de una ruta.
String _nombreArchivo(String ruta) => ruta.split(RegExp(r'[\\/]')).last;

/// `true` si [nombre] es una foto creada por la app (`zapato_<n>.<ext>`).
bool esFotoDeZapato(String nombre) => nombre.startsWith(_prefijoFoto);

/// Borra una foto de zapato de la carpeta de la app.
///
/// Por seguridad solo elimina archivos que la propia app creó (carpeta de
/// documentos y prefijo `zapato_`): nunca toca fotos de la galería. Si el
/// archivo no existe o falla el borrado, no hace nada.
Future<void> deleteShoeImage(String? ruta) async {
  if (ruta == null || ruta.isEmpty) return;
  try {
    if (!esFotoDeZapato(_nombreArchivo(ruta))) return;
    final directory = await getApplicationDocumentsDirectory();
    final archivo = File(ruta);
    if (archivo.parent.path != directory.path) return;
    if (await archivo.exists()) await archivo.delete();
  } catch (_) {
    // Una foto que no se pudo borrar no debe romper el flujo del usuario.
  }
}

/// Fotos tomadas o elegidas dentro de un formulario que aún no se guardó.
///
/// Cada foto nueva se copia a la carpeta de la app al instante. Si el usuario
/// la cambia por otra o cierra el formulario sin guardar, esas copias se borran
/// para no dejar archivos que ningún registro usa.
class PhotoSession {
  final _pendientes = <String>[];

  /// Registra una foto nueva y descarta las anteriores de esta sesión.
  void register(String ruta) {
    for (final anterior in _pendientes) {
      deleteShoeImage(anterior);
    }
    _pendientes
      ..clear()
      ..add(ruta);
  }

  /// Cierra la sesión: borra las fotos pendientes, salvo la que quedó guardada ([keep]).
  void release({String? keep}) {
    for (final ruta in _pendientes) {
      if (ruta != keep) deleteShoeImage(ruta);
    }
    _pendientes.clear();
  }
}
