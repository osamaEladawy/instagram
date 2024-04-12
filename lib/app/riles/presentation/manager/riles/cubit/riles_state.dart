part of 'riles_cubit.dart';

sealed class RilesState extends Equatable {
  const RilesState();
}

final class RilesInitial extends RilesState {
  @override
  List<Object> get props => [];
}

final class RilesLoading extends RilesState {
  @override
  List<Object> get props => [];
}

final class RilesLoaded extends RilesState {
    final List<RilesEntity> riles;

  const RilesLoaded({required this.riles});

  @override
  List<Object> get props => [riles];
}

final class RilesFailure extends RilesState {
  @override
  List<Object> get props => [];
}
