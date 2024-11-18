import 'package:firebase_auth/firebase_auth.dart';
import 'package:inistagram/features/user/domain/repositories/user_repository.dart';

class LoginWithGoogleUseCase {
  final UserRepository authRepository;

  LoginWithGoogleUseCase({required this.authRepository});

  Future<UserCredential> call() async {
    return await authRepository.loginWithGoogle();
  }
}
