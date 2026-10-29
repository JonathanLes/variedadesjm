import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/modules/backup/controller/backup_providers.dart';
import 'package:variedadesjm/modules/backup/service/backup_models.dart';

/// Hoja inferior para eliminar copias antiguas (la más reciente queda protegida).
class AdministrationBackupSheet extends ConsumerStatefulWidget {
  const AdministrationBackupSheet({super.key, required this.folderUri});

  final String folderUri;

  @override
  ConsumerState<AdministrationBackupSheet> createState() =>
      _AdministrationBackupSheetState();
}

class _AdministrationBackupSheetState
    extends ConsumerState<AdministrationBackupSheet> {
  List<BackupEntry> _backups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final service = await ref.read(backupServiceProvider.future);
      final list = await service.listBackups(folderUri: widget.folderUri);
      if (!mounted) return;
      setState(() {
        _backups = List.of(list);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _aviso(String titulo, String mensaje, IconData icono, Color color) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(icono, size: 48, color: color),
        title: Text(titulo, textAlign: TextAlign.center),
        content: Text(mensaje, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmar() => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Eliminar copia'),
          content: const Text(
              '¿Seguro que deseas eliminar esta copia? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

  Future<void> _eliminar(BackupEntry entry) async {
    try {
      final service = await ref.read(backupServiceProvider.future);
      await service.deleteBackup(entry.fileId);
      if (!mounted) return;
      _aviso('Copia eliminada', 'La copia de seguridad fue borrada.',
          Icons.check_circle_outline, Theme.of(context).colorScheme.primary);
    } catch (e) {
      if (!mounted) return;
      _aviso('Error', 'No se pudo eliminar: $e', Icons.error_outline,
          Theme.of(context).colorScheme.error);
      _load();
    }
  }

  Future<void> _eliminarManual(BackupEntry entry) async {
    if (await _confirmar() != true || !mounted) return;
    setState(() => _backups.removeWhere((e) => e.fileId == entry.fileId));
    await _eliminar(entry);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: scheme.onSurfaceVariant.withValues(alpha: .4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.folder, color: scheme.primary, size: 28),
                const SizedBox(width: 12),
                Text('Administrar copias',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Desliza hacia la izquierda o usa el botón para eliminar copias antiguas. '
              'Por seguridad, la copia más reciente está protegida.',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _backups.isEmpty
                    ? Center(
                        child: Text('No hay copias de seguridad.',
                            style: TextStyle(color: scheme.onSurfaceVariant)))
                    : ListView.builder(
                        itemCount: _backups.length,
                        itemBuilder: (context, index) {
                          final entry = _backups[index];
                          final reciente = index == 0;
                          return Dismissible(
                            key: ValueKey(entry.fileId),
                            direction: reciente
                                ? DismissDirection.none
                                : DismissDirection.endToStart,
                            background: Container(
                              color: scheme.error,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: Icon(Icons.delete_outline, color: scheme.onError),
                            ),
                            confirmDismiss: (_) => _confirmar(),
                            onDismissed: (_) {
                              setState(() =>
                                  _backups.removeWhere((e) => e.fileId == entry.fileId));
                              _eliminar(entry);
                            },
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                              leading: CircleAvatar(
                                backgroundColor: reciente
                                    ? scheme.primaryContainer
                                    : scheme.surfaceContainerHighest,
                                child: Icon(
                                  reciente
                                      ? Icons.verified_user_outlined
                                      : Icons.insert_drive_file_outlined,
                                  color: reciente
                                      ? scheme.onPrimaryContainer
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                              title: Text(entry.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(fechaCopia(entry.createdAt)),
                              trailing: reciente
                                  ? Tooltip(
                                      message: 'Copia protegida (más reciente)',
                                      child: Icon(Icons.shield,
                                          color: scheme.primary.withValues(alpha: .5)),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.delete_outline, color: scheme.error),
                                      tooltip: 'Eliminar copia',
                                      onPressed: () => _eliminarManual(entry),
                                    ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
