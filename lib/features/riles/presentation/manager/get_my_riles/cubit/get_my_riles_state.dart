part of 'get_my_riles_cubit.dart';

sealed class GetMyRilesState extends Equatable {
  const GetMyRilesState();
}

final class GetMyRilesInitial extends GetMyRilesState {
  @override
  List<Object> get props => [];
}

final class GetMyRilesLoading extends GetMyRilesState {
  @override
  List<Object> get props => [];
}

final class GetMyRilesLoaded extends GetMyRilesState {
  final RilesEntity? myRiles;

  const GetMyRilesLoaded({required this.myRiles});

  @override
  List<Object> get props => [myRiles!];
}

final class GetMyRilesFailure extends GetMyRilesState {
  @override
  List<Object> get props => [];
}
