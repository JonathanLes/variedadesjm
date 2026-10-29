/// Copias de seguridad: crear, restaurar y administrar archivos en una carpeta elegida.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saf_util/saf_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/backup/boundary/widgets/administration_backup_sheet.dart';
import 'package:variedadesjm/modules/backup/boundary/widgets/backup_tutorial_dialog.dart';
import 'package:variedadesjm/modules/backup/controller/backup_providers.dart';
import 'package:variedadesjm/modules/backup/service/backup_models.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

const _folderKey = 'backup_folder_uri';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _working = false;
  String? _status;

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

  /// Devuelve la carpeta guardada o pide una nueva al usuario.
  Future<String?> _carpeta() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final guardada = prefs.getString(_folderKey);

    if (guardada != null) {
      try {
        if (await SafUtil().exists(guardada, true) == true) return guardada;
      } catch (e) {
        debugPrint('Carpeta de copias inaccesible: $e');
      }
      await prefs.remove(_folderKey);
      _aviso(
        'Carpeta no encontrada',
        'La carpeta de copias fue eliminada o movida. Presiona de nuevo la opción '
            'para elegir una nueva carpeta.',
        Icons.folder_off_outlined,
        AppColors.warning,
      );
      return null;
    }

    try {
      final dir = await SafUtil().pickDirectory(
        writePermission: true,
        persistablePermission: true,
      );
      if (dir != null) {
        await prefs.setString(_folderKey, dir.uri);
        return dir.uri;
      }
    } catch (e) {
      debugPrint('Error al elegir la carpeta: $e');
    }
    return null;
  }

  Future<void> _crear() async {
    final carpeta = await _carpeta();
    if (carpeta == null || !mounted) return;

    final nombre = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva copia de seguridad', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa un nombre para identificar esta copia:'),
            const SizedBox(height: 16),
            TextField(
              controller: nombre,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Nombre de la copia',
                hintText: 'Ej. Cierre de mes',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    final texto = nombre.text.trim();
    nombre.dispose();
    if (ok != true) return;

    setState(() {
      _working = true;
      _status = 'Generando copia de seguridad...';
    });
    try {
      final service = await ref.read(backupServiceProvider.future);
      final r = await service.createBackup(
        backupName: texto.isEmpty ? 'Manual' : texto,
        folderUri: carpeta,
      );
      if (!mounted) return;
      setState(() => _working = false);
      _aviso(
        'Copia creada',
        'Se guardó la copia correctamente'
            '${r.fotos > 0 ? ' junto con ${r.fotos} foto(s) de tus zapatos' : ''}.',
        Icons.check_circle_outline,
        AppColors.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _working = false);
      _aviso('Error', 'No se pudo crear la copia: $e', Icons.error_outline,
          Theme.of(context).colorScheme.error);
    }
  }

  Future<void> _restaurar() async {
    final carpeta = await _carpeta();
    if (carpeta == null || !mounted) return;

    setState(() {
      _working = true;
      _status = 'Buscando copias disponibles...';
    });
    try {
      final service = await ref.read(backupServiceProvider.future);
      final copias = await service.listBackups(folderUri: carpeta);
      if (!mounted) return;
      if (copias.isEmpty) {
        setState(() => _working = false);
        _aviso(
          'Sin copias de seguridad',
          'No se encontraron copias válidas en la carpeta seleccionada.',
          Icons.folder_open_outlined,
          AppColors.warning,
        );
        return;
      }

      final elegida = await showDialog<BackupEntry>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Selecciona una copia', textAlign: TextAlign.center),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: copias.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(Icons.insert_drive_file_outlined,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(copias[i].displayName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                    '${fechaCopia(copias[i].createdAt)}${i == 0 ? ' · más reciente' : ''}'),
                onTap: () => Navigator.of(context).pop(copias[i]),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
      if (elegida == null || !mounted) {
        if (mounted) setState(() => _working = false);
        return;
      }

      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded,
              size: 44, color: AppColors.warning),
          title: const Text('¿Restaurar esta copia?', textAlign: TextAlign.center),
          content: Text(
            'Se reemplazarán TODOS los datos actuales (ventas, reservas, inventario, '
            'gastos y catálogos) por los de "${elegida.displayName}". '
            'Esta acción no se puede deshacer.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Restaurar'),
            ),
          ],
        ),
      );
      if (confirmar != true || !mounted) {
        if (mounted) setState(() => _working = false);
        return;
      }

      setState(() => _status = 'Restaurando datos...');
      final payload = await service.downloadBackup(elegida.fileId);
      await service.restoreBackup(payload: payload, folderUri: carpeta);
      // Reabre la base: todos los listados y reportes vuelven a leer los datos nuevos.
      ref.invalidate(sembastDatabaseProvider);
      if (!mounted) return;
      setState(() => _working = false);
      _aviso(
        'Restauración exitosa',
        'Los datos se restauraron desde: ${elegida.displayName}',
        Icons.check_circle_outline,
        AppColors.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _working = false);
      _aviso('Error', 'No se pudo restaurar la copia: $e', Icons.error_outline,
          Theme.of(context).colorScheme.error);
    }
  }

  Future<void> _administrar() async {
    final carpeta = await _carpeta();
    if (carpeta == null || !mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .8,
        child: AdministrationBackupSheet(folderUri: carpeta),
      ),
    );
  }

  void _tutorial() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackupTutorialDialog(
        onUnderstand: () => Navigator.of(context).pop(),
        buttonText: '¡Listo, entendido!',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copias de seguridad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Ver tutorial',
            onPressed: _tutorial,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Icon(Icons.backup_outlined, size: 48, color: scheme.primary),
                  const SizedBox(height: 12),
                  const Text('Protege la información de tu negocio',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    'Guarda ventas, reservas, inventario, gastos y fotos en una carpeta de '
                    'tu dispositivo. Puedes restaurarlas cuando quieras o llevarlas a otro '
                    'teléfono.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_working)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(_status ?? 'Procesando...',
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          _Accion(
            icon: Icons.cloud_upload_outlined,
            titulo: 'Hacer copia de seguridad',
            detalle: 'Guardar tus datos de forma segura',
            onTap: _working ? null : _crear,
          ),
          _Accion(
            icon: Icons.cloud_download_outlined,
            titulo: 'Restaurar copia de seguridad',
            detalle: 'Cargar datos desde una carpeta',
            onTap: _working ? null : _restaurar,
          ),
          _Accion(
            icon: Icons.settings_backup_restore_outlined,
            titulo: 'Administrar copias',
            detalle: 'Elimina copias antiguas para liberar espacio',
            onTap: _working ? null : _administrar,
          ),
        ],
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  const _Accion({
    required this.icon,
    required this.titulo,
    required this.detalle,
    required this.onTap,
  });

  final IconData icon;
  final String titulo;
  final String detalle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Opacity(
            opacity: onTap == null ? .5 : 1,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.primary.withValues(alpha: .12),
                    child: Icon(icon, color: scheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titulo,
                            style: const TextStyle(
                                fontSize: 15.5, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(detalle, style: const TextStyle(fontSize: 12.5)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
