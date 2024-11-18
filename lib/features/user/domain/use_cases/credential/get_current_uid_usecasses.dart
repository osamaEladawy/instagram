
import '../../repositories/user_repository.dart';

class GetCurrentUidUseCases{
  final UserRepository repository;

  GetCurrentUidUseCases({required this.repository});

  Future<String>call()async{
    return repository.getCurrentUid();
  }

}