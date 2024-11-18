
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:inistagram/features/riles/domain/entities/riles_image_entity.dart';

class RilesEntity extends Equatable {
  final String? statusId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final Timestamp? createdAt;
  final String? email;
  final String? caption;
  final List<RilesImageEntity>? stories;

  const RilesEntity(
      {
        this.statusId,
        this.imageUrl,
        this.uid,
        this.username,
        this.profileUrl,
        this.createdAt,
        this.email,
        this.caption,
        this.stories
      });

  @override
  List<Object?> get props => [
    statusId,
    imageUrl,
    uid,
    username,
    profileUrl,
    createdAt,
    email,
    caption,
    stories
  ];
}