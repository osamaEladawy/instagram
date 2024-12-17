part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class ChangesTheme extends SettingsState {}

final class ThemeApp extends SettingsState {
  final bool isDarkMode;

  ThemeApp({
    required this.isDarkMode,
  });
}
