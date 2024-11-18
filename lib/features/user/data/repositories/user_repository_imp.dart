import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/data_sources/user_remote_data_sources.dart';

class UserRepositoryImp implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImp({required this.userRemoteDataSource});

  @override
  Future createUserEntity(UserEntity userEntity) async =>
      userRemoteDataSource.createUserEntity(userEntity);

  @override
  Stream<List<UserEntity>> getAllUsers() => userRemoteDataSource.getAllUsers();

  @override
  Future<String> getCurrentUid() async => userRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUserUid(String userUid) =>
      userRemoteDataSource.getSingleUserUid(userUid);

  @override
  Future<bool> isSignIn() async => userRemoteDataSource.isSignIn();

  @override
  Future<void> signOut() async => userRemoteDataSource.signOut();

  @override
  Future<void> updateUserEntity(UserEntity userEntity) async =>
      userRemoteDataSource.updateUserEntity(userEntity);

  @override
  Future<UserCredential> login(
          {required String email, required String password}) async =>
      userRemoteDataSource.login(email: email, password: password);

  @override
  Future<UserCredential> loginWithGoogle() async =>
      userRemoteDataSource.loginWithGoogle();

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String bio,
    required Uint8List image,
  }) async =>
      userRemoteDataSource.register(
        email: email,
        password: password,
        name: name,
        bio: bio,
        image: image,
      );
}
