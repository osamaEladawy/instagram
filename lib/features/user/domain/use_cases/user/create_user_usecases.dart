
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class CreateUserUseCase{
  final UserRepository repository;

  CreateUserUseCase({required this.repository});

  Future call (UserEntity userEntity)async{
    return  repository.createUserEntity(userEntity);
  }
}