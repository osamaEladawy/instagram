
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetSingleUserUseCases{
  final UserRepository repository;

  GetSingleUserUseCases({required this.repository});

  Future<Stream<List<UserEntity>>>call (String userUid)async{
    return repository.getSingleUserUid(userUid);
  }
}