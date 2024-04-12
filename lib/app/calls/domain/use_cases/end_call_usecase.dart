





import '../entities/call_entity.dart';
import '../repositories/call_repository.dart';

class EndCallUseCase {

  final CallRepository repository;

  const EndCallUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.endCall(call);
  }
}