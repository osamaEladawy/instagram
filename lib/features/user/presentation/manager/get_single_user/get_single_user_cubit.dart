import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/my_app.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/get_single_user_usecases.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUseCases getSingleUserUseCases;
  
  GetSingleUserCubit({
    required this.getSingleUserUseCases,
}) : super(GetSingleUserInitial());

 static final  GetSingleUserCubit _getSingleUserCubit=  BlocProvider.of(navigatorKey.currentContext!);
 static GetSingleUserCubit get instance => _getSingleUserCubit;

  Future<void>getSingleUser({required String userId})async {
    emit(GetSingleUserLoading());
    final streamResponse = await getSingleUserUseCases.call(userId);
    streamResponse.listen((userEntity) {
      emit(GetSingleUserLoaded(userEntity: userEntity.first));
    });
  }

}
