import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variedadesjm/controllers/providers/sembast_app_state_providers.dart';
import 'package:variedadesjm/modules/dashboard/boundary/pages/dashboard_page.dart';
import 'package:variedadesjm/shared/themes/app_theme.dart';

/// Punto de entrada de Variedades JM: conecta Riverpod con el tema persistente.
void main() {
  // En lugar de la pantalla gris, muestra qué falló para poder corregirlo.
  ErrorWidget.builder = (details) => Material(
        color: const Color(0xFFFFF4F2),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                'Ocurrió un error al mostrar esta pantalla:\n\n${details.exceptionAsString()}',
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFF8A1F11), fontSize: 13),
              ),
            ),
          ),
        ),
      );
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
