import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/use_cases/create_riles_usecase.dart';
import 'package:inistagram/features/riles/domain/use_cases/delete_riles_usecase.dart';
import 'package:inistagram/features/riles/domain/use_cases/get_riles_usecase.dart';
import 'package:inistagram/features/riles/domain/use_cases/seen_riles_update_usecase.dart';
import 'package:inistagram/features/riles/domain/use_cases/update_only_image_riles_usecase.dart';
import 'package:inistagram/features/riles/domain/use_cases/update_riles_usecase.dart';

part 'riles_state.dart';

class RilesCubit extends Cubit<RilesState> {
  final CreateRilesUseCase createStatusUseCase;
  final DeleteRilesUseCase deleteStatusUseCase;
  final UpdateRilesUseCase updateStatusUseCase;
  final GetRilesUseCase getStatusesUseCase;
  final UpdateOnlyImageRilesUseCase updateOnlyImageStatusUseCase;
  final SeenRilesUpdateUseCase seenStatusUpdateUseCase;
  RilesCubit(
      {required this.createStatusUseCase,
      required this.deleteStatusUseCase,
      required this.getStatusesUseCase,
      required this.seenStatusUpdateUseCase,
      required this.updateOnlyImageStatusUseCase,
      required this.updateStatusUseCase})
      : super(RilesInitial());

        Future<void> getStRiles({required RilesEntity status}) async {
    try {

      emit(RilesLoading());
      final streamResponse = getStatusesUseCase.call(status);
      streamResponse.listen((statuses) {
        print("statuses = $statuses");
        emit(RilesLoaded(riles: statuses));
      });

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }


  Future<void> createStatus({required RilesEntity status}) async {

    try {
      await createStatusUseCase.call(status);

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }

  Future<void> deleteStatus({required RilesEntity status}) async {

    try {
      await deleteStatusUseCase.call(status);

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }

  Future<void> updateStatus({required RilesEntity status}) async {

    try {
      await updateStatusUseCase.call(status);

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }

  Future<void> updateOnlyImageStatus({required RilesEntity status}) async {

    try {
      await updateOnlyImageStatusUseCase.call(status);

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }

  Future<void> seenStatusUpdate({required String statusId, required int imageIndex, required String userId}) async {

    try {
      await seenStatusUpdateUseCase.call(statusId, imageIndex, userId);

    } on SocketException {
      emit(RilesFailure());
    } catch(_) {
      emit(RilesFailure());
    }
  }

}
