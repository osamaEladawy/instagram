import 'package:inistagram/features/save_posts/cubit/save_posts_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void savePostsInjections(){
  sl.registerFactory<SavePostsCubit>(()=>SavePostsCubit());
}