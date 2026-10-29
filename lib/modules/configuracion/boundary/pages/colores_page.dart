import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_app_state_providers.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Paleta de colores de la aplicación.
class ColoresPage extends ConsumerWidget {
  const ColoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(paletteProvider);
    final notifier = ref.read(paletteProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Colores de la app')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Elige la paleta que más te guste.'),
          const SizedBox(height: 4),
          const Text('El cambio se guarda automáticamente en este dispositivo.',
              style: TextStyle(fontSize: 12.5)),
          const SizedBox(height: 12),
          for (final palette in AppColors.all)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: identical(palette, selected)
                        ? scheme.primary
                        : scheme.outlineVariant,
                    width: identical(palette, selected) ? 2 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () => notifier.select(palette),
                  minVerticalPadding: 14,
                  leading: Icon(
                    identical(palette, selected)
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: scheme.primary,
                  ),
                  title: Text(_nameOf(palette),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final color in [palette.primary, palette.accent, palette.background])
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: color,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _nameOf(AppPalette palette) {
    if (palette == AppColors.marino) return 'Azul marino';
    if (palette == AppColors.vino) return 'Vino y porcelana';
    if (palette == AppColors.acero) return 'Acero y arena';
    return 'Cobre y café';
  }
}
