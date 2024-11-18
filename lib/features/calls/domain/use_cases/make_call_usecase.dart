



import '../entities/call_entity.dart';
import '../repositories/call_repository.dart';

class MakeCallUseCase {

  final CallRepository repository;

  const MakeCallUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.makeCall(call);
  }
}