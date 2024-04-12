


import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class UpdateOnlyImageStatusUseCase {

  final StatusRepository repository;

  const UpdateOnlyImageStatusUseCase({required this.repository});

  Future<void> call(StatusEntity status) async {
    return await repository.updateOnlyImageStatus(status);
  }
}