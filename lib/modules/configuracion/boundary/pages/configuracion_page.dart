import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_app_state_providers.dart';
import 'package:variedadesjm/shared/layouts/app_layout.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

/// Permite cambiar la apariencia de la aplicación y preferencias operativas.
class ConfiguracionPage extends ConsumerWidget {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(paletteProvider);
    final notifier = ref.read(paletteProvider.notifier);
    return AppLayout(
      currentIndex: 0,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Configuración',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Personaliza la apariencia del panel sin perder consistencia visual.',
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paleta de colores',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'El cambio se guarda automáticamente en este dispositivo.',
                  ),
                  const SizedBox(height: 18),
                  ...AppColors.all.map(
                    (palette) => ListTile(
                      selected: identical(palette, selected),
                      leading: Icon(
                        identical(palette, selected)
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(_nameOf(palette)),
                      onTap: () => notifier.select(palette),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            [
                                  palette.primary,
                                  palette.accent,
                                  palette.background,
                                ]
                                .map(
                                  (color) => Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: color,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ],
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
