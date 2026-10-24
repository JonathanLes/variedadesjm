/// Contiene los providers persistentes de tema, paleta y estado global.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:variedadesjm/controllers/providers/sembast_core_providers.dart';
import 'package:variedadesjm/shared/themes/colors.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref);
});

/// Persiste la paleta elegida para que el panel conserve la preferencia.
final paletteProvider = StateNotifierProvider<PaletteNotifier, AppPalette>((
  ref,
) {
  return PaletteNotifier(ref);
});

/// Controla la paleta activa sin mezclar preferencias con widgets.
class PaletteNotifier extends StateNotifier<AppPalette> {
  PaletteNotifier(this._ref) : super(AppColors.marino) {
    _load();
  }

  final Ref _ref;
  static const _key = 'app_palette';

  Future<void> _load() async {
    final preferences = await _ref.read(sharedPreferencesProvider.future);
    final index =
        preferences.getInt(_key) ?? AppColors.all.indexOf(AppColors.marino);
    if (index >= 0 && index < AppColors.all.length)
      state = AppColors.all[index];
  }

  /// Guarda y aplica una paleta del catálogo soportado.
  Future<void> select(AppPalette palette) async {
    final index = AppColors.all.indexOf(palette);
    if (index < 0) return;
    state = palette;
    final preferences = await _ref.read(sharedPreferencesProvider.future);
    await preferences.setInt(_key, index);
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;
  static const _themeModePrefKey = 'theme_mode_is_dark';

  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final isDark = prefs.getBool(_themeModePrefKey) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_themeModePrefKey, mode == ThemeMode.dark);
  }
}

class AppState {
  final bool isBootstrapping;

  AppState({this.isBootstrapping = true});

  AppState copyWith({bool? isBootstrapping}) {
    return AppState(isBootstrapping: isBootstrapping ?? this.isBootstrapping);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier(ref);
});

class AppStateNotifier extends StateNotifier<AppState> {
  final Ref ref;

  AppStateNotifier(this.ref) : super(AppState()) {
    bootstrapApp();
  }

  Future<void> bootstrapApp() async {
    state = state.copyWith(isBootstrapping: false);
  }

  Future<void> deleteLocalData() async {
    ref.invalidate(sembastDatabaseProvider);

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'variedadesjm.db');
    await databaseFactoryIo.deleteDatabase(dbPath);

    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.clear();

    state = AppState(isBootstrapping: false);
  }
}
