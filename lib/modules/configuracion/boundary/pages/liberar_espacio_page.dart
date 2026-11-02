/// Liberar espacio: borra, solo cuando el usuario lo pide, las fotos que ningún producto usa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/modules/configuracion/service/photo_cleanup.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

class LiberarEspacioPage extends ConsumerStatefulWidget {
  const LiberarEspacioPage({super.key});

  @override
  ConsumerState<LiberarEspacioPage> createState() => _LiberarEspacioPageState();
}

class _LiberarEspacioPageState extends ConsumerState<LiberarEspacioPage> {
  PhotoReport? _reporte;
  Object? _error;
  bool _busy = true;
  String? _resultado;

  @override
  void initState() {
    super.initState();
    _revisar();
  }

  Future<void> _revisar() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final db = await ref.read(sembastDatabaseProvider.future);
      final reporte = await revisarFotos(db);
      if (!mounted) return;
      setState(() {
        _reporte = reporte;
        _busy = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _busy = false;
      });
    }
  }

  Future<void> _borrar() async {
    final reporte = _reporte;
    if (reporte == null || reporte.huerfanas.isEmpty) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_sweep_outlined, size: 44, color: AppColors.danger),
        title: const Text('¿Borrar archivos sin uso?', textAlign: TextAlign.center),
        content: Text(
          'Se borrarán ${reporte.huerfanas.length} foto(s) '
          '(${formatoBytes(reporte.bytesHuerfanas)}) que ningún producto usa. '
          'Las fotos de tus productos no se tocan. Esta acción no se puede deshacer.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    setState(() => _busy = true);
    final borradas = await borrarHuerfanas(reporte);
    if (!mounted) return;
    _resultado = 'Se borraron $borradas archivo(s) y se liberaron '
        '${formatoBytes(reporte.bytesHuerfanas)}.';
    await _revisar();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reporte = _reporte;
    return Scaffold(
      appBar: AppBar(title: const Text('Liberar espacio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Icon(Icons.cleaning_services_outlined, size: 46, color: scheme.primary),
                  const SizedBox(height: 12),
                  const Text('Fotos sin uso',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    'Con el tiempo pueden quedar fotos guardadas que ya ningún producto '
                    'usa. Aquí puedes revisarlas y borrarlas para recuperar espacio.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Text('No se pudo revisar el espacio: $_error',
                style: const TextStyle(color: AppColors.danger))
          else if (reporte != null) ...[
            if (_resultado != null)
              Card(
                color: AppColors.success.withValues(alpha: .12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.success),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_resultado!)),
                    ],
                  ),
                ),
              ),
            _Dato(
              icono: Icons.photo_library_outlined,
              etiqueta: 'Fotos en uso',
              valor: '${reporte.enUso} · ${formatoBytes(reporte.bytesEnUso)}',
            ),
            _Dato(
              icono: Icons.delete_outline,
              etiqueta: 'Fotos sin uso',
              valor: '${reporte.huerfanas.length} · ${formatoBytes(reporte.bytesHuerfanas)}',
              color: reporte.huerfanas.isEmpty ? null : AppColors.warning,
            ),
            const SizedBox(height: 14),
            if (reporte.huerfanas.isEmpty)
              Text('Todo en orden: no hay fotos que borrar.',
                  textAlign: TextAlign.center, style: TextStyle(color: context.muted))
            else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _borrar,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: Text('Borrar ${reporte.huerfanas.length} archivo(s)'),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
              onPressed: _revisar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Volver a revisar'),
            ),
            const SizedBox(height: 12),
            Text(
              'Las fotos creadas hace menos de 5 minutos se omiten por seguridad.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: context.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color? color;

  const _Dato({required this.icono, required this.etiqueta, required this.valor, this.color});

  @override
  Widget build(BuildContext context) {
    final tone = color ?? Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icono, color: tone),
            const SizedBox(width: 12),
            Expanded(child: Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text(valor, style: TextStyle(fontWeight: FontWeight.w800, color: tone)),
          ],
        ),
      ),
    );
  }
}
