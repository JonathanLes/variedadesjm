import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_app_state_providers.dart';
import 'package:variedadesjm/modules/dashboard/boundary/pages/dashboard_page.dart';
import 'package:variedadesjm/shared/themes/app_theme.dart';

/// Punto de entrada de Variedades JM: conecta Riverpod con el tema persistente.
void main() {
  runApp(const ProviderScope(child: VariedadesJmApp()));
}

/// Configura la aplicación Material y expone el dashboard como inicio.
class VariedadesJmApp extends ConsumerWidget {
  const VariedadesJmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final mode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Variedades JM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromPalette(palette, ThemeMode.light),
      darkTheme: AppTheme.fromPalette(palette, ThemeMode.dark),
      themeMode: mode,
      home: const DashboardPage(),
    );
  }
}

/// Alias de compatibilidad para integraciones y pruebas existentes.
class MyApp extends VariedadesJmApp {
  const MyApp({super.key});
}
