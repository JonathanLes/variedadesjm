import 'package:flutter/material.dart';

/// Una opción que aparece al abrir el botón "+".
class SpeedDialAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SpeedDialAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

/// Botón flotante único que, al tocarlo, oscurece la pantalla y despliega
/// sus opciones hacia arriba con su etiqueta, como en WhatsApp.
class SpeedDialFab extends StatelessWidget {
  final List<SpeedDialAction> actions;

  const SpeedDialFab({super.key, required this.actions});

  Future<void> _open(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final rect = origin & box.size;
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withValues(alpha: .6),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, _, _) =>
          _SpeedDialOverlay(anchor: rect, actions: actions),
      transitionBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'speed_dial_fab',
      tooltip: 'Nueva operación',
      onPressed: () => _open(context),
      child: const Icon(Icons.add_rounded, size: 30),
    );
  }
}

class _SpeedDialOverlay extends StatelessWidget {
  final Rect anchor;
  final List<SpeedDialAction> actions;

  const _SpeedDialOverlay({required this.anchor, required this.actions});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Toca en cualquier parte para cerrar.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            right: size.width - anchor.right,
            bottom: size.height - anchor.top + 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final action in actions.reversed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ActionRow(action: action),
                  ),
              ],
            ),
          ),
          // El botón vuelve a su sitio convertido en una "X".
          Positioned.fromRect(
            rect: anchor,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close_rounded, color: scheme.primary, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final SpeedDialAction action;

  const _ActionRow({required this.action});

  @override
  Widget build(BuildContext context) {
    void run() {
      Navigator.of(context).pop();
      action.onTap();
    }

    return InkWell(
      onTap: run,
      borderRadius: BorderRadius.circular(30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              action.label,
              style: const TextStyle(
                color: Color(0xFF1B2A41),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: action.color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3)),
              ],
            ),
            child: Icon(action.icon, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
