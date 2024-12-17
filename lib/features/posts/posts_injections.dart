import 'package:inistagram/features/posts/cubit/posts_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void postsInjections(){
  sl.registerFactory<PostsCubit>(()=>PostsCubit());
}