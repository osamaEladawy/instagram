


import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class UpdateStatusUseCase {

  final StatusRepository repository;

  const UpdateStatusUseCase({required this.repository});

  Future<void> call(StatusEntity status) async {
    return await repository.updateStatus(status);
  }
}