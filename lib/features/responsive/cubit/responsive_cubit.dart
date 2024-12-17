import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'responsive_state.dart';

class ResponsiveCubit extends Cubit<ResponsiveState> {
  ResponsiveCubit() : super(ResponsiveInitial());
}
