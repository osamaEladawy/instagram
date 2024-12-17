import 'package:inistagram/features/search/cubit/search_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void searchInjection() {
  sl.registerFactory<SearchCubit>(() => SearchCubit());
}
