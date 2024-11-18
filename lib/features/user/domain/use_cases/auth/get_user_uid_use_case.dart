import 'package:inistagram/features/user/domain/repositories/user_repository.dart';

class GetUserUidUseCase {
  final UserRepository authRepository;

  GetUserUidUseCase({required this.authRepository});
  Future<String> call() async {
    return await authRepository.getCurrentUid();
  }
}
