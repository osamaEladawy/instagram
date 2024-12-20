

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inistagram/features/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/features/riles/domain/entities/riles_image_entity.dart';


class RilesModel extends RilesEntity {

  final String? statusId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final Timestamp? createdAt;
  final String? email;
  final String? caption;
  final List<RilesImageEntity>? stories;

  const RilesModel(
      {this.statusId,
        this.imageUrl,
        this.uid,
        this.username,
        this.profileUrl,
        this.createdAt,
        this.email,
        this.caption,
        this.stories}) : super(
      statusId: statusId,
      imageUrl: imageUrl,
      uid: uid,
      username: username,
      profileUrl: profileUrl,
      createdAt: createdAt,
      email: email,
      caption: caption,
      stories: stories
  );

  factory RilesModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    final stories = snap['stories'] as List;
    List<RilesImageEntity> storiesData =
    stories.map((element) => RilesImageEntity.fromJson(element)).toList();

    return RilesModel(
        stories: storiesData,
        statusId: snap['statusId'],
        username: snap['username'],
        email: snap['email'],
        createdAt: snap['createdAt'],
        uid: snap['uid'],
        profileUrl: snap['profileUrl'],
        imageUrl: snap['imageUrl'],
        caption: snap['caption']
    );
  }

  Map<String, dynamic> toDocument() => {
    "stories": stories?.map((story) => story.toJson()).toList(),
    "statusId": statusId,
    "username": username,
    "email": email,
    "createdAt": createdAt,
    "uid": uid,
    "profileUrl": profileUrl,
    "imageUrl": imageUrl,
    "caption": caption,
  };
}