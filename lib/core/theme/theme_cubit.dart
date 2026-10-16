import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box(AppConstants.settingsBox);
    final saved = box.get(AppConstants.themeKey, defaultValue: 'system') as String;
    emit(_parseThemeMode(saved));
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark: return 'dark';
      case ThemeMode.system: return 'system';
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.themeKey, _serializeThemeMode(mode));
    emit(mode);
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.system:
        setTheme(ThemeMode.light);
      case ThemeMode.light:
        setTheme(ThemeMode.dark);
      case ThemeMode.dark:
        setTheme(ThemeMode.system);
    }
  }
}
