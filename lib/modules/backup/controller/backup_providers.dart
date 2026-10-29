import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/backup/service/backup_service.dart';

/// Servicio de copias; se reconstruye si la base se vuelve a abrir.
final backupServiceProvider = FutureProvider<BackupService>((ref) async {
  final db = await ref.watch(sembastDatabaseProvider.future);
  return BackupService(db);
});
