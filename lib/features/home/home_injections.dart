import 'package:inistagram/features/home/cubit/home_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void homeInjection() {
  sl.registerFactory<HomeCubit>(()=>HomeCubit());
}
