import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/credential/get_current_uid_usecasses.dart';
import '../../../domain/use_cases/credential/is_sign_in_usecases.dart';
import '../../../domain/use_cases/credential/sign_out_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUseCases getCurrentUidUseCases;
  final IsSignInUseCases isSignInUseCases;
  final SignOutUseCases signOutUseCases;

  AuthCubit(
      {required this.isSignInUseCases,
      required this.signOutUseCases,
      required this.getCurrentUidUseCases})
      : super(AuthInitial());




  Future<void> appStarted() async{

    try{
      bool isSignIn=await isSignInUseCases.call();

      if (isSignIn){
        final uid = await getCurrentUidUseCases.call();
        emit(Authenticated(userUid: uid));
      }else {
        emit(UnAuthenticated());
      }

    }catch(_){
      emit(UnAuthenticated());
    }

  }

  Future<void> loggedIn() async{
    try{
      final uid= await getCurrentUidUseCases.call();
      emit(Authenticated(userUid: uid));
    }catch(_){
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async{
    try{
      await signOutUseCases.call();
      emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }
}
