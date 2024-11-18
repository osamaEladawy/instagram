import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/use_cases/get_my_riles_usecase.dart';

part 'get_my_riles_state.dart';

class GetMyRilesCubit extends Cubit<GetMyRilesState> {
  GetMyRilesCubit({required this.getMyStatusUseCase})
      : super(GetMyRilesInitial());
  final GetMyRilesUseCase getMyStatusUseCase;

  Future<void> getMyStatus({required String uid}) async {
    try {
      emit(GetMyRilesLoading());
      final streamResponse = getMyStatusUseCase.call(uid);
      streamResponse.listen((statuses) {
        print("Mystatuses = $statuses");
        if (statuses.isEmpty) {
          emit(const GetMyRilesLoaded(myRiles: null));
        } else {
          emit(GetMyRilesLoaded(myRiles: statuses.first));
        }
      });
    } on SocketException {
      emit(GetMyRilesFailure());
    } catch (_) {
      emit(GetMyRilesFailure());
    }
  }
}
