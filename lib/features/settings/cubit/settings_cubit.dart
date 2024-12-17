import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/storage/pref_services.dart';
import 'package:inistagram/my_app.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  static final SettingsCubit _settingsCubit = BlocProvider.of(navigatorKey.currentContext!);

  static SettingsCubit get instance => _settingsCubit;

  bool isDarkMode = false;

  void toggleTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    PrefServices.saveData(key: "dark", value: this.isDarkMode);
    emit(ThemeApp(isDarkMode: this.isDarkMode));
  }

  bool changeStateForSwish() {
    if (PrefServices.getData(key: "dark") == true) {
      return this.isDarkMode = true;
    }
    return this.isDarkMode = false;
  }

  // ThemeData getThemeData() {
  //   if (PrefServices.getData(key: "dark") == true) {
  //     return darkTheme;
  //   }
  //   return lightTheme;
  // }
}
