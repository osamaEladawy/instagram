
import '../entities/user_entity.dart';

abstract class UserRepository{


  Future<bool>isSignIn();
  Future<void>signOut();
  Future<String>getCurrentUid();
  Future<void>createUserEntity(UserEntity userEntity);
  Future<void>updateUserEntity(UserEntity userEntity);

  Stream<List<UserEntity>>getAllUsers();
  Stream<List<UserEntity>>getSingleUserUid(String userUid);


}