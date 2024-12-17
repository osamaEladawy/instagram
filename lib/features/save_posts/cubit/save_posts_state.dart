part of 'save_posts_cubit.dart';

sealed class SavePostsState extends Equatable {
  const SavePostsState();

  @override
  List<Object> get props => [];
}

final class SavePostsInitial extends SavePostsState {}
