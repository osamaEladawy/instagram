part of 'responsive_cubit.dart';

sealed class ResponsiveState extends Equatable {
  const ResponsiveState();

  @override
  List<Object> get props => [];
}

final class ResponsiveInitial extends ResponsiveState {}
