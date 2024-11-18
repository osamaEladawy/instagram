




import '../entities/call_entity.dart';
import '../repositories/call_repository.dart';

class SaveCallHistoryUseCase {

  final CallRepository repository;

  const SaveCallHistoryUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.saveCallHistory(call);
  }
}