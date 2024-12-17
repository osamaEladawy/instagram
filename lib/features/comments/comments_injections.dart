import 'package:inistagram/features/comments/cubit/comments_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void commentsInjections(){
  sl.registerFactory<CommentsCubit>(()=>CommentsCubit());
}