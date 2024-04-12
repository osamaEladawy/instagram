import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/create_user_usecases.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final CreateUserUseCases createUserUseCases;

  CredentialCubit({
    required this.createUserUseCases,
}) : super(CredentialInitial());


  Future<void>submitProfileInfo({required UserEntity userEntity})async{
    try {
      await createUserUseCases.call(userEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }







}
