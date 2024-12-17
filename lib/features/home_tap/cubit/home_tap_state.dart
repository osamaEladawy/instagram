part of 'home_tap_cubit.dart';

@immutable
sealed class HomeTapState {}

final class HomeTapInitial extends HomeTapState {}

final class SelectPage extends HomeTapState {
  final int pageIndex;

  SelectPage({required this.pageIndex});
}
