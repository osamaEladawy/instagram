import 'package:firebase_auth/firebase_auth.dart';
import 'package:inistagram/features/user/domain/repositories/user_repository.dart';

class LoginUseCases {
  final UserRepository auhRepository;

  LoginUseCases({required this.auhRepository});

  Future<UserCredential>call({
    required String email,
    required String password,
  }) async {
    return await auhRepository.login(
      email: email,
      password: password,
    );
  }
}
