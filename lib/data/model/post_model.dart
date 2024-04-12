import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late final String? uid;
  late final String? username;
  late final  String? description;
  late final  datePublished;
  late final  String? postId;
  late final String? postUrl;
  late final String? profileImage;
  late final  List? likes;
  late final  bool? isSave;

  PostModel({
    required this.uid,
    required this.username,
    required this.description,
    required this.datePublished,
    required this.postId,
     required this.postUrl,
    required this.profileImage,
    required this.likes,
    required this.isSave,
  });

  Map<String, dynamic> toSnapshot() =>
      {
        "uid": uid,
        "username": username,
        "description": description,
        "datePublished": datePublished,
        "postId": postId,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes":likes,
        "isSave":isSave,
      };

  PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String,dynamic> result = snapshot.data() as Map<String, dynamic>;
    //PostModel(
    uid = result["uid"];
    username = result["username"];
    description = result["description"];
    datePublished = result["datePublished"];
    postId = result["postId"];
    postUrl = result["postUrl"];
    profileImage = result["profileImage"];
    likes = result['likes'];
    isSave = result['isSave'];
    //);

  }
}
