
import '../../repositories/user_repository.dart';

class SignOutUseCases{
  final UserRepository repository;

  SignOutUseCases({required this.repository});


  Future<void> call()async{
    return repository.signOut();
  }
}