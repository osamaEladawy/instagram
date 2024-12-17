import 'package:inistagram/features/settings/cubit/settings_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void settingInjection(){
  sl.registerFactory<SettingsCubit>(()=>SettingsCubit());
}