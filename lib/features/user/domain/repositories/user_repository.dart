import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future createUserEntity( UserEntity userEntity);
  Future<void> updateUserEntity(UserEntity userEntity);

  Stream<List<UserEntity>> getAllUsers();
  Stream<List<UserEntity>> getSingleUserUid(String userUid);

  Future<UserCredential> login(
      {required String email, required String password});
  Future<UserCredential> loginWithGoogle();
  
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String bio,
    required Uint8List image,
  });
}
