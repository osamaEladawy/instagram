part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchUsers extends SearchState {}

final class ShowUsers extends SearchState {
  final bool isShowUsers;

  ShowUsers({required this.isShowUsers});
}
