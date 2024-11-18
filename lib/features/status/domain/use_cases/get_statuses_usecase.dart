


import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class GetStatusesUseCase {

  final StatusRepository repository;

  const GetStatusesUseCase({required this.repository});

  Stream<List<StatusEntity>> call(StatusEntity status) {
    return repository.getStatuses(status);
  }
}