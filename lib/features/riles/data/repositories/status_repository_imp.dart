


import 'package:inistagram/features/riles/data/remote/data_sources/status_remote_data_source.dart';
import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/repositories/riles_repository.dart';

class RilesRepositoryImpl implements RilesRepository {
  final RilesRemoteDataSource remoteDataSource;

  RilesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createRiles(RilesEntity status) async => remoteDataSource.createRiles(status);

  @override
  Future<void> deleteRiles(RilesEntity riles) async => remoteDataSource.deleteRiles(riles);

  @override
  Stream<List<RilesEntity>> getMyRiles(String uid) => remoteDataSource.getMyRiles(uid);

  @override
  Future<List<RilesEntity>> getMyRilesFuture(String uid) async => remoteDataSource.getMyRilesFuture(uid);

  @override
  Stream<List<RilesEntity>> getRiles(RilesEntity riles) => remoteDataSource.getRiles(riles);

  @override
  Future<void> seenRilesUpdate(String statusId, int imageIndex, String userId) async => remoteDataSource.seenRilesUpdate(statusId, imageIndex, userId);

  @override
  Future<void> updateOnlyImageRiles(RilesEntity riles) async => remoteDataSource.updateOnlyImageRiles(riles);

  @override
  Future<void> updateRiles(RilesEntity riles) async => remoteDataSource.updateRiles(riles);

}