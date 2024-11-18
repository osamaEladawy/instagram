



import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';

class GetMyRilesUseCase {

  final RilesRepository repository;

  const GetMyRilesUseCase({required this.repository});

  Stream<List<RilesEntity>> call(String uid) {
    return repository.getMyRiles(uid);
  }
}