


import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class GetMyStatusUseCase {

  final StatusRepository repository;

  const GetMyStatusUseCase({required this.repository});

  Stream<List<StatusEntity>> call(String uid) {
    return repository.getMyStatus(uid);
  }
}