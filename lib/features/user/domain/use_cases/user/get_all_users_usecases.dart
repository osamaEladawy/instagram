
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetAllUsersUseCases{
  final UserRepository repository;

  GetAllUsersUseCases({required this.repository});

  Future<Stream<List<UserEntity>>> call()async{
    return repository.getAllUsers();
  }
}