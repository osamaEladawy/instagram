



import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';

class GetMyRilesFutureUseCase {

  final RilesRepository repository;

  const GetMyRilesFutureUseCase({required this.repository});

  Future<List<RilesEntity>> call(String uid) async {
    return repository.getMyRilesFuture(uid);
  }
}