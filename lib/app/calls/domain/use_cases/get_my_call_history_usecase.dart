






import '../entities/call_entity.dart';
import '../repositories/call_repository.dart';

class GetMyCallHistoryUseCase {

  final CallRepository repository;

  const GetMyCallHistoryUseCase({required this.repository});

  Stream<List<CallEntity>> call(String uid)  {
    return repository.getMyCallHistory(uid);
  }
}