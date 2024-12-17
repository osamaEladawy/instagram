import 'package:inistagram/features/home_tap/cubit/home_tap_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void homeTapInjection(){
  sl.registerFactory<HomeTapCubit>(()=>HomeTapCubit());
}