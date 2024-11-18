import 'package:cloud_firestore/cloud_firestore.dart';

class CommentSavePostModel {
  late final String? useruid;
  late final String? commentSavePostId;
  late final String? username;
  late final String? profilePic;
  late final datePublished;
  late final String? text;
  late final String? commentId;
  late final String? postId;
  late final List? likes;

  CommentSavePostModel({
    required this.useruid,
    required this.commentSavePostId,
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
        "commentSavePostId": commentSavePostId,
        "username": username,
        "profilePic": profilePic,
        "datePublished": datePublished,
        "text": text,
        "commentId": commentId,
        "postId": postId,
        "likes": likes
      };

  CommentSavePostModel.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data() as Map<String, dynamic>;
    //PostModel(
    useruid = result["useruid"];
    commentSavePostId = result["commentSavePostId"];
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
