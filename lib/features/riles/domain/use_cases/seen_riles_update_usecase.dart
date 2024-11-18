


import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';


class SeenRilesUpdateUseCase {

  final RilesRepository repository;

  const SeenRilesUpdateUseCase({required this.repository});

  Future<void> call(String statusId, int imageIndex, String userId) async {
    return await repository.seenRilesUpdate(statusId, imageIndex, userId);
  }
}