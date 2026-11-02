/// Detecta y borra las fotos de zapatos que ningún modelo usa (archivos huérfanos).
library;

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/shared/utils/image_store.dart';

/// Las fotos creadas hace menos de esto se ignoran: pueden estar en un
/// formulario abierto que todavía no se guardó.
const _margenReciente = Duration(minutes: 5);

class PhotoReport {
  /// Fotos que sí usa algún modelo.
  final int enUso;
  final int bytesEnUso;

  /// Fotos que ningún modelo usa y pueden borrarse.
  final List<File> huerfanas;
  final int bytesHuerfanas;

  const PhotoReport({
    required this.enUso,
    required this.bytesEnUso,
    required this.huerfanas,
    required this.bytesHuerfanas,
  });
}

/// Nombres de [todos] que son fotos de la app y no aparecen en [referenciados].
List<String> nombresHuerfanos(Iterable<String> todos, Set<String> referenciados) => [
      for (final nombre in todos)
        if (esFotoDeZapato(nombre) && !referenciados.contains(nombre)) nombre,
    ];

String _nombre(String ruta) => ruta.split(RegExp(r'[\\/]')).last;

/// Revisa la carpeta de la app y la base de datos. No borra nada.
Future<PhotoReport> revisarFotos(Database db) async {
  final directory = await getApplicationDocumentsDirectory();
  final registros = await stringMapStoreFactory.store(SembastStores.zapato).find(db);
  final referenciados = <String>{
    for (final r in registros)
      if ('${r.value['imagenPath'] ?? ''}'.isNotEmpty) _nombre('${r.value['imagenPath']}'),
  };

  final archivos = <String, File>{};
  await for (final entidad in directory.list(followLinks: false)) {
    if (entidad is File && esFotoDeZapato(_nombre(entidad.path))) {
      archivos[_nombre(entidad.path)] = entidad;
    }
  }

  final nombresOrfanos = nombresHuerfanos(archivos.keys, referenciados).toSet();
  final limite = DateTime.now().subtract(_margenReciente);
  final huerfanas = <File>[];
  var bytesHuerfanas = 0;
  var enUso = 0;
  var bytesEnUso = 0;
  for (final entry in archivos.entries) {
    final stat = await entry.value.stat();
    if (nombresOrfanos.contains(entry.key)) {
      if (stat.modified.isBefore(limite)) {
        huerfanas.add(entry.value);
        bytesHuerfanas += stat.size;
      }
    } else {
      enUso++;
      bytesEnUso += stat.size;
    }
  }
  return PhotoReport(
    enUso: enUso,
    bytesEnUso: bytesEnUso,
    huerfanas: huerfanas,
    bytesHuerfanas: bytesHuerfanas,
  );
}

/// Borra las fotos huérfanas del [reporte]; devuelve cuántas se eliminaron.
Future<int> borrarHuerfanas(PhotoReport reporte) async {
  var borradas = 0;
  for (final archivo in reporte.huerfanas) {
    try {
      if (await archivo.exists()) {
        await archivo.delete();
        borradas++;
      }
    } catch (_) {}
  }
  return borradas;
}

/// `1536` → `1.5 KB`, `5242880` → `5.0 MB`.
String formatoBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
