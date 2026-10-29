import 'package:flutter/material.dart';

/// Guía de 3 pasos para elegir la carpeta donde se guardan las copias.
class BackupTutorialDialog extends StatefulWidget {
  const BackupTutorialDialog({
    super.key,
    required this.onUnderstand,
    this.buttonText = 'Entendido',
  });

  final VoidCallback onUnderstand;
  final String buttonText;

  @override
  State<BackupTutorialDialog> createState() => _BackupTutorialDialogState();
}

class _BackupTutorialDialogState extends State<BackupTutorialDialog> {
  final _controller = PageController();
  int _page = 0;

  static const _steps = [
    (
      icon: Icons.create_new_folder_outlined,
      title: 'Elige una carpeta segura',
      desc: 'La primera vez que crees una copia se te pedirá elegir o crear una carpeta '
          'en tu dispositivo. Te recomendamos crear una carpeta solo para tus copias.',
    ),
    (
      icon: Icons.folder_open_outlined,
      title: 'Selecciona la carpeta',
      desc: 'Entra a la carpeta que elegiste y presiona la opción "Usar esta carpeta".',
    ),
    (
      icon: Icons.verified_user_outlined,
      title: 'Y confirma',
      desc: 'Confirma tu selección. Asegúrate de elegir la carpeta correcta para que tus '
          'copias queden guardadas de forma segura y accesible.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final last = _page == _steps.length - 1;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 340,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _steps.length,
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: scheme.primary.withValues(alpha: .12),
                          child: Icon(step.icon, size: 44, color: scheme.primary),
                        ),
                        const SizedBox(height: 22),
                        Text(step.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Text(step.desc,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _steps.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i ? scheme.primary : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (last) {
                      widget.onUnderstand();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(last ? widget.buttonText : 'Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
