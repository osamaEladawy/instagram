
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/data_sources/user_remote_data_sources.dart';

class UserRepositoryImp implements UserRepository{
final UserRemoteDataSource userRemoteDataSource;

UserRepositoryImp({required this.userRemoteDataSource});

  @override
  Future<void> createUserEntity(UserEntity userEntity)async=>userRemoteDataSource.createUserEntity(userEntity);

  @override
  Stream<List<UserEntity>> getAllUsers()=>userRemoteDataSource.getAllUsers();

  @override
  Future<String> getCurrentUid() async=>userRemoteDataSource.getCurrentUid();



  @override
  Stream<List<UserEntity>> getSingleUserUid(String userUid) =>userRemoteDataSource.getSingleUserUid(userUid);

  @override
  Future<bool> isSignIn()async=>userRemoteDataSource.isSignIn();


  @override
  Future<void> signOut()async =>userRemoteDataSource.signOut();

  @override
  Future<void> updateUserEntity(UserEntity userEntity) async=>userRemoteDataSource.updateUserEntity(userEntity);



}