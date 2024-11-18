



import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';

class GetRilesUseCase {

  final RilesRepository repository;

  const GetRilesUseCase({required this.repository});

  Stream<List<RilesEntity>> call(RilesEntity riles) {
    return repository.getRiles(riles);
  }
}