import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:inistagram/features/user/domain/repositories/user_repository.dart';

class RegisterUseCases {
  final UserRepository auhRepository;

  RegisterUseCases({required this.auhRepository});

  Future<UserCredential> call({
    required String email,
    required String password,
    required String name,
    required String bio,
    required Uint8List image,
  }) async {
    return await auhRepository.register(
      email: email,
      password: password,
      name: name,
      image: image,
      bio: bio,
    );
  }
}
