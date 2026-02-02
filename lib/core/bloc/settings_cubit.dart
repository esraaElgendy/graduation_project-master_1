import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../utils/app_preferences.dart';

// States
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({required this.themeMode, required this.locale});

  @override
  List<Object> get props => [themeMode, locale];

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

// Cubit
class SettingsCubit extends Cubit<SettingsState> {
  final AppPreferences _preferences;

  SettingsCubit(this._preferences)
      : super(const SettingsState(themeMode: ThemeMode.system, locale: Locale('en'))) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isDark = await _preferences.getThemeMode();
    final langCode = await _preferences.getLocale();

    ThemeMode mode = ThemeMode.system;
    if (isDark != null) {
      mode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    Locale locale = const Locale('en');
    if (langCode != null) {
      locale = Locale(langCode);
    }

    emit(state.copyWith(themeMode: mode, locale: locale));
  }

  Future<void> toggleTheme(bool isDark) async {
    await _preferences.saveThemeMode(isDark);
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleLocale() async {
    final newLocale = state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    await _preferences.saveLocale(newLocale.languageCode);
    emit(state.copyWith(locale: newLocale));
  }
  
  Future<void> setLocale(Locale locale) async {
    await _preferences.saveLocale(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }
}
