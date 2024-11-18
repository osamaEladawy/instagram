import 'package:inistagram/features/user/domain/repositories/user_repository.dart';

class LogoutUseCases {
  final UserRepository auhRepository;

  LogoutUseCases({required this.auhRepository});

  Future<void> call() async {
    return await auhRepository.signOut();
  }
}
