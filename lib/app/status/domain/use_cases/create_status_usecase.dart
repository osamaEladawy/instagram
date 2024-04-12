



import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class CreateStatusUseCase {

  final StatusRepository repository;

  const CreateStatusUseCase({required this.repository});

  Future<void> call(StatusEntity status) async {
    return await repository.createStatus(status);
  }
}