// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user_entity.dart';


class UserModel extends UserEntity{
  late final String? uid;
  late final String? username;
  late final String? email;
  late final String? bio;
  late final String? imageUrl;
  late final List? following;
  late final List? followers;
  late final List? saves;
  late final bool? isOnline;
  late final dateWhenLogOut;
  late final bool? isPrivate;


  UserModel({required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.imageUrl,
    required this.following,
    required this.followers,
    required this.saves,
    required this.isOnline,
    required this.dateWhenLogOut,
    required this.isPrivate,
  });

  Map<String, dynamic> toSnapshot() =>
      {
        "uid": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "imageUrl": imageUrl,
        "following": following,
        "followers": followers,
        "saves": followers,
        "isOnline":isOnline,
        "dateWhenLogOut":dateWhenLogOut,
        "isPrivate":isPrivate,
      };

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data()! as Map<String, dynamic>;
    // UserModel(
    uid = result["uid"];
    username = result["username"];
    email = result["email"];
    bio = result["bio"];
    imageUrl = result["imageUrl"];
    following = result["following"];
    followers = result["followers"];
    saves = result["saves"];
    isOnline =result["isOnline"];
    dateWhenLogOut = result["dateWhenLogOut"];
    isPrivate = result["isPrivate"];
    //);

  }
}
