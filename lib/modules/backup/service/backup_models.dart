/// Modelos y utilidades puras de las copias de seguridad (sin dependencias de plataforma).
library;

const String backupPrefix = 'variedadesjm_';
const String backupPhotoPrefix = 'variedadesjm_foto_';
const int backupSchemaVersion = 1;

/// Contenido de un archivo de copia: registros de cada almacén de la base.
class BackupPayload {
  BackupPayload({
    required this.schemaVersion,
    required this.exportedAt,
    required this.stores,
  });

  final int schemaVersion;
  final DateTime exportedAt;

  /// nombre del almacén -> lista de {key, value}.
  final Map<String, List<Map<String, dynamic>>> stores;

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'exportedAt': exportedAt.toIso8601String(),
        'stores': stores,
      };

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final raw = json['stores'];
    final parsed = <String, List<Map<String, dynamic>>>{};
    if (raw is Map) {
      for (final entry in raw.entries) {
        final value = entry.value;
        parsed[entry.key.toString()] = value is List
            ? value
                .whereType<Map>()
                .map((row) => Map<String, dynamic>.from(row))
                .toList(growable: false)
            : const <Map<String, dynamic>>[];
      }
    }
    return BackupPayload(
      schemaVersion: int.tryParse(json['schemaVersion']?.toString() ?? '') ?? 1,
      exportedAt:
          DateTime.tryParse(json['exportedAt']?.toString() ?? '') ?? DateTime.now(),
      stores: parsed,
    );
  }
}

class BackupEntry {
  const BackupEntry({required this.fileId, required this.fileName, this.createdAt});

  final String fileId;
  final String fileName;
  final DateTime? createdAt;

  String get displayName => backupDisplayName(fileName);
}

class BackupResult {
  const BackupResult({required this.fileName, required this.fotos});
  final String fileName;
  final int fotos;
}

class BackupException implements Exception {
  BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

String _pad(int n) => n.toString().padLeft(2, '0');

/// `variedadesjm_<nombre>_<YYYYMMDD_HHMMSS>.json`
String backupFileName(String name, DateTime now) {
  var clean =
      name.trim().replaceAll(' ', '_').replaceAll(RegExp(r'[^\w\-]'), '');
  if (clean.isEmpty) clean = 'copia';
  final stamp = '${now.year}${_pad(now.month)}${_pad(now.day)}_'
      '${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}';
  return '$backupPrefix${clean}_$stamp.json';
}

bool isBackupFile(String name) =>
    name.startsWith(backupPrefix) &&
    !name.startsWith(backupPhotoPrefix) &&
    name.endsWith('.json');

/// Fecha incrustada en el nombre, o null si no sigue el patrón.
DateTime? parseBackupDate(String fileName) {
  final match = RegExp(r'_(\d{8})_(\d{6})\.json$').firstMatch(fileName);
  if (match == null) return null;
  final d = match.group(1)!;
  final t = match.group(2)!;
  try {
    return DateTime(
      int.parse(d.substring(0, 4)),
      int.parse(d.substring(4, 6)),
      int.parse(d.substring(6, 8)),
      int.parse(t.substring(0, 2)),
      int.parse(t.substring(2, 4)),
      int.parse(t.substring(4, 6)),
    );
  } catch (_) {
    return null;
  }
}

String backupDisplayName(String fileName) {
  if (!fileName.startsWith(backupPrefix)) return fileName.replaceAll('.json', '');
  final name = fileName
      .replaceFirst(backupPrefix, '')
      .replaceAll(RegExp(r'_\d{8}_\d{6}\.json$'), '');
  return name.isEmpty ? 'Copia de seguridad' : name.replaceAll('_', ' ');
}

/// Nombre del archivo (sin carpetas) de una ruta de foto.
String photoBaseName(String path) => path.split(RegExp(r'[\\/]')).last;

String fechaCopia(DateTime? d) => d == null
    ? 'Fecha desconocida'
    : '${_pad(d.day)}/${_pad(d.month)}/${d.year} ${_pad(d.hour)}:${_pad(d.minute)}';
