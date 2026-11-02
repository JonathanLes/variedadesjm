/// Crea, lista, elimina y restaura copias de seguridad en una carpeta elegida por el usuario
/// (Storage Access Framework de Android). Respalda toda la base y las fotos de los zapatos.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';
import 'package:sembast/sembast.dart';
import 'package:variedadesjm/controllers/database/sembast_stores.dart';
import 'package:variedadesjm/modules/backup/service/backup_models.dart';

class BackupService {
  BackupService(this._db);

  final Database _db;

  static const List<String> _storeNames = [
    SembastStores.cambio,
    SembastStores.categoriaGasto,
    SembastStores.categoriaZapato,
    SembastStores.cliente,
    SembastStores.compra,
    SembastStores.cuadreCaja,
    SembastStores.gasto,
    SembastStores.inventario,
    SembastStores.marca,
    SembastStores.proveedor,
    SembastStores.reservaDetalle,
    SembastStores.reserva,
    SembastStores.usuario,
    SembastStores.ventaDetalle,
    SembastStores.venta,
    SembastStores.zapato,
  ];

  StoreRef<String, Map<String, dynamic>> _store(String name) =>
      stringMapStoreFactory.store(name);

  // --- Crear ---
  Future<BackupResult> createBackup({
    required String backupName,
    required String folderUri,
  }) async {
    final stores = <String, List<Map<String, dynamic>>>{};
    final fotos = <String>{};
    for (final name in _storeNames) {
      final rows = await _store(name).find(_db);
      stores[name] = [
        for (final row in rows) {'key': row.key, 'value': row.value},
      ];
      for (final row in rows) {
        final path = row.value['imagenPath'];
        if (path is String && path.isNotEmpty) fotos.add(path);
      }
    }

    final copiadas = await _guardarFotos(folderUri, fotos);

    final fileName = backupFileName(backupName, DateTime.now());
    final payload = BackupPayload(
      schemaVersion: backupSchemaVersion,
      exportedAt: DateTime.now().toUtc(),
      stores: stores,
    );
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(payload.toJson())));
    await SafStream().writeFileBytes(
      folderUri,
      fileName,
      'application/json',
      bytes,
      overwrite: true,
    );
    return BackupResult(fileName: fileName, fotos: copiadas);
  }

  /// Copia a la carpeta las fotos que aún no están (el nombre de cada foto es único).
  Future<int> _guardarFotos(String folderUri, Set<String> rutas) async {
    if (rutas.isEmpty) return 0;
    final existentes = <String>{};
    try {
      for (final f in await SafUtil().list(folderUri)) {
        existentes.add(f.name);
      }
    } catch (_) {}

    var total = 0;
    for (final ruta in rutas) {
      final base = photoBaseName(ruta);
      final file = File(ruta);
      if (!await file.exists()) continue;
      total++;
      final nombre = '$backupPhotoPrefix$base';
      if (existentes.contains(nombre)) continue;
      await SafStream().writeFileBytes(
        folderUri,
        nombre,
        _mime(base),
        await file.readAsBytes(),
        overwrite: true,
      );
    }
    return total;
  }

  String _mime(String name) {
    final ext = name.toLowerCase().split('.').last;
    if (ext == 'png') return 'image/png';
    if (ext == 'webp') return 'image/webp';
    return 'image/jpeg';
  }

  // --- Fotos sin uso en la carpeta ---

  /// Revisa qué fotos de la carpeta ya no necesita ninguna copia ni la app.
  /// No borra nada. Si alguna copia no se puede leer, falla para no arriesgar fotos.
  Future<BackupPhotoReport> revisarFotosCarpeta(String folderUri) async {
    final archivos = await SafUtil().list(folderUri);
    final necesarias = <String>{};
    var copias = 0;

    // Fotos que usa la base de datos actual.
    for (final name in _storeNames) {
      final rows = await _store(name).find(_db);
      for (final row in rows) {
        final path = row.value['imagenPath'];
        if (path is String && path.isNotEmpty) necesarias.add(photoBaseName(path));
      }
    }

    // Fotos que nombra cada copia que sigue en la carpeta (una a la vez, para no llenar la RAM).
    for (final file in archivos) {
      if (!isBackupFile(file.name)) continue;
      final payload = await downloadBackup(file.uri.toString());
      copias++;
      for (final rows in payload.stores.values) {
        for (final row in rows) {
          final value = row['value'];
          final path = value is Map ? value['imagenPath'] : null;
          if (path is String && path.isNotEmpty) necesarias.add(photoBaseName(path));
        }
      }
    }

    final porNombre = {
      for (final f in archivos)
        if (f.name.startsWith(backupPhotoPrefix)) f.name: f,
    };
    final huerfanas = fotosSinUso(porNombre.keys, necesarias).toSet();
    final sinUso = <BackupPhotoFile>[];
    var bytes = 0;
    for (final nombre in huerfanas) {
      final f = porNombre[nombre]!;
      final int? largo = f.length;
      final size = largo ?? 0;
      bytes += size;
      sinUso.add(BackupPhotoFile(uri: f.uri.toString(), name: nombre, bytes: size));
    }
    return BackupPhotoReport(
      enUso: porNombre.length - sinUso.length,
      sinUso: sinUso,
      bytesSinUso: bytes,
      copias: copias,
    );
  }

  /// Borra de la carpeta las fotos indicadas; devuelve cuántas se eliminaron.
  Future<int> borrarFotosCarpeta(List<BackupPhotoFile> fotos) async {
    var borradas = 0;
    for (final foto in fotos) {
      try {
        await SafUtil().delete(foto.uri, false);
        borradas++;
      } catch (_) {}
    }
    return borradas;
  }

  // --- Listar ---
  Future<List<BackupEntry>> listBackups({required String folderUri}) async {
    try {
      final files = await SafUtil().list(folderUri);
      final entries = <BackupEntry>[];
      for (final file in files) {
        if (!isBackupFile(file.name)) continue;
        var date = parseBackupDate(file.name);
        final int? lastMod = file.lastModified;
        if (date == null && lastMod != null && lastMod > 0) {
          date = DateTime.fromMillisecondsSinceEpoch(lastMod);
        }
        entries.add(BackupEntry(
          fileId: file.uri.toString(),
          fileName: file.name,
          createdAt: date,
        ));
      }
      entries.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return entries;
    } catch (_) {
      return const <BackupEntry>[];
    }
  }

  // --- Eliminar ---
  Future<void> deleteBackup(String fileUri) async {
    try {
      await SafUtil().delete(fileUri, false);
    } catch (_) {
      throw BackupException('El archivo de la copia no existe o ya fue eliminado.');
    }
  }

  // --- Leer ---
  Future<BackupPayload> downloadBackup(String fileUri) async {
    try {
      final bytes = await SafStream().readFileBytes(fileUri);
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is! Map<String, dynamic>) {
        throw BackupException('El archivo no es válido.');
      }
      return BackupPayload.fromJson(decoded);
    } on BackupException {
      rethrow;
    } catch (_) {
      throw BackupException('No se encontró la copia seleccionada o no se pudo leer.');
    }
  }

  // --- Restaurar ---
  Future<void> restoreBackup({
    required BackupPayload payload,
    required String folderUri,
  }) async {
    if (payload.schemaVersion != backupSchemaVersion) {
      throw BackupException('La versión de esta copia no es compatible.');
    }

    final docs = await getApplicationDocumentsDirectory();
    final remotas = <String, String>{};
    try {
      for (final f in await SafUtil().list(folderUri)) {
        if (f.name.startsWith(backupPhotoPrefix)) {
          remotas[f.name.substring(backupPhotoPrefix.length)] = f.uri.toString();
        }
      }
    } catch (_) {}

    // 1) Fotos: se copian primero; si falta alguna, el registro queda sin foto.
    final rutasNuevas = <String, String?>{};
    for (final rows in payload.stores.values) {
      for (final row in rows) {
        final value = row['value'];
        if (value is! Map) continue;
        final ruta = value['imagenPath'];
        if (ruta is! String || ruta.isEmpty || rutasNuevas.containsKey(ruta)) continue;
        final base = photoBaseName(ruta);
        final destino = File('${docs.path}/$base');
        if (await destino.exists()) {
          rutasNuevas[ruta] = destino.path;
        } else if (remotas.containsKey(base)) {
          try {
            final bytes = await SafStream().readFileBytes(remotas[base]!);
            await destino.writeAsBytes(bytes, flush: true);
            rutasNuevas[ruta] = destino.path;
          } catch (_) {
            rutasNuevas[ruta] = null;
          }
        } else {
          rutasNuevas[ruta] = null;
        }
      }
    }

    // 2) Base de datos: reemplazo completo en una sola transacción.
    await _db.transaction((txn) async {
      for (final name in _storeNames) {
        final store = _store(name);
        await store.delete(txn);
        for (final row in payload.stores[name] ?? const <Map<String, dynamic>>[]) {
          final key = row['key']?.toString();
          final raw = row['value'];
          if (key == null || key.isEmpty || raw is! Map) continue;
          final value = Map<String, dynamic>.from(raw);
          final ruta = value['imagenPath'];
          if (ruta is String && ruta.isNotEmpty) value['imagenPath'] = rutasNuevas[ruta];
          await store.record(key).put(txn, value);
        }
      }
    });
  }
}
