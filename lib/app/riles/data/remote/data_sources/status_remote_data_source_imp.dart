
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inistagram/app/riles/data/remote/data_sources/status_remote_data_source.dart';
import 'package:inistagram/app/riles/data/remote/models/riles_model.dart';
import 'package:inistagram/app/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/app/riles/domain/entities/riles_image_entity.dart';

import '../../../../../core/const/firebase_collection_const.dart';

class RilesRemoteDataSourceImpl implements RilesRemoteDataSource {
  final FirebaseFirestore fireStore;

  RilesRemoteDataSourceImpl({required this.fireStore});
  
  @override
  Future<void> createRiles(RilesEntity riles) async{
       final statusCollection =
    fireStore.collection("Riles");


    final statusId = statusCollection.doc().id;


    final newStatus = RilesModel(
      imageUrl: riles.imageUrl,
      profileUrl: riles.profileUrl,
      uid: riles.uid,
      createdAt: riles.createdAt,
      email: riles.email,
      username: riles.username,
      statusId: statusId,
      caption: riles.caption,
      stories: riles.stories!,
    ).toDocument();


    final statusDocRef = await statusCollection.doc(statusId).get();

    try {
      if (!statusDocRef.exists) {
        statusCollection.doc(statusId).set(newStatus);
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while creating status");
    }

  }
  
  @override
  Future<void> deleteRiles(RilesEntity riles) async{
    final statusCollection =
    fireStore.collection("Riles");

    try {
      statusCollection.doc(riles.statusId).delete();
    } catch (e) {
      print("some error occur while deleting status");
    }
  }
  
  @override
  Stream<List<RilesEntity>> getMyRiles(String uid) {
      final statusCollection =
    fireStore.collection("Riles")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));


    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24),),),)
        .map((e) => RilesModel.fromSnapshot(e))
        .toList());
  }
  
  @override
  Future<List<RilesEntity>> getMyRilesFuture(String uid) {
       final statusCollection =
    fireStore.collection("Riles")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ),);



    return statusCollection.get().then((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => RilesModel.fromSnapshot(e))
        .toList());

  }
  
  @override
  Stream<List<RilesEntity>> getRiles(RilesEntity riles) {
    final statusCollection =
    fireStore.collection("Riles")
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));


    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => RilesModel.fromSnapshot(e))
        .toList());
  }
  
  @override
  Future<void> seenRilesUpdate(String statusId, int imageIndex, String userId) async{
      try {
      final statusDocRef = fireStore
          .collection("Riles")
          .doc(statusId);

      final statusDoc = await statusDocRef.get();

      final stories = List<Map<String, dynamic>>.from(statusDoc.get('stories'));

      final viewersList = List<String>.from(stories[imageIndex]['viewers']);

      // Check if the user ID is already present in the viewers list
      if (!viewersList.contains(userId)) {
        viewersList.add(userId);

        // Update the viewers list for the specified image index
        stories[imageIndex]['viewers'] = viewersList;

        await statusDocRef.update({
          'stories': stories,
        });
      }


    } catch (error) {
      print('Error updating viewers list: $error');
    }
  }
  
  @override
  Future<void> updateOnlyImageRiles(RilesEntity riles) async{
final statusCollection =
    fireStore.collection(FirebaseCollectionConst.status);

    final statusDocRef = await statusCollection.doc(riles.statusId).get();

    try {
      if (statusDocRef.exists) {

        final existingStatusData = statusDocRef.data()!;
        final createdAt = existingStatusData['createdAt'].toDate();

        // check if the existing status is still within its 24 hours period
        if (createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
          // if it is, update the existing status with the new stores (images, or videos)

          final stories = List<Map<String, dynamic>>.from(statusDocRef.get('stories'));

          stories.addAll(riles.stories!.map((e) => RilesImageEntity.toJsonStatic(e)));
          // final updatedStories = List<StatusImageEntity>.from(existingStatusData['stories'])
          //   ..addAll(status.stories!);

          await statusCollection.doc(riles.statusId).update({
            'stories': stories,
            'imageUrl': stories[0]['url']
          });
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while updating status stories");
    }  }
  
  @override
  Future<void> updateRiles(RilesEntity riles) async{
    final statusCollection =
    fireStore.collection("Riles");

    Map<String, dynamic> statusInfo = {};

    if (riles.imageUrl != "" && riles.imageUrl != null) {
      statusInfo['imageUrl'] = riles.imageUrl;
    }

    if (riles.stories != null) {
      statusInfo['stories'] = riles.stories;
    }

    statusCollection.doc(riles.statusId).update(statusInfo);
  }

}