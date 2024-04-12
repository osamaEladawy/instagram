

import '../entities/riles_entity.dart';

abstract class RilesRepository {

  Future<void> createRiles(RilesEntity riles);
  Future<void> updateRiles(RilesEntity riles);
  Future<void> updateOnlyImageRiles(RilesEntity riles);
  Future<void> seenRilesUpdate(String statusId, int imageIndex, String userId);
  Future<void> deleteRiles(RilesEntity riles);
  Stream<List<RilesEntity>> getRiles(RilesEntity riles);
  Stream<List<RilesEntity>> getMyRiles(String uid);
  Future<List<RilesEntity>> getMyRilesFuture(String uid);
}