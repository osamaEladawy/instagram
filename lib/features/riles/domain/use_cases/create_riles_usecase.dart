



import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';


class CreateRilesUseCase {

  final RilesRepository repository;

  const CreateRilesUseCase({required this.repository});

  Future<void> call(RilesEntity riles) async {
    return await repository.createRiles(riles);
  }
}