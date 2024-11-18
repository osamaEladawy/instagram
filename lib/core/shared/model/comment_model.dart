import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late final String? useruid;
  late final String? username;
  late final String? profilePic;
  late final datePublished;
  late final String? text;
  late final String? commentId;
  late final String? postId;
  late final List? likes;

  CommentModel({
    required this.useruid,
    required this.username,
    required this.profilePic,
    required this.datePublished,
    required this.text,
    required this.commentId,
    required this.postId,
    required this.likes,
  });

  Map<String, dynamic> toSnapshot() => {
        "useruid": useruid,
        "username": username,
        "profilePic": profilePic,
        "datePublished": datePublished,
        "text": text,
        "commentId": commentId,
        "postId": postId,
        "likes": likes
      };

  CommentModel.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data() as Map<String, dynamic>;
    //PostModel(
    useruid = result["useruid"];
    username = result["username"];
    profilePic = result["profilePic"];
    datePublished = result["datePublished"];
    text = result["text"];
    commentId = result["commentId"];
    postId = result["postId"];
    likes = result['likes'];
    //);
  }
}
