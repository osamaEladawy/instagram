import 'package:cloud_firestore/cloud_firestore.dart';

class SavePostModel {
  late final String? useruidForPost;
  late final String? savePostId;
  late final String? currentUserId;
  late final String? usernameForPost;
  late final  String? descriptionForPost;
  late final  datePublishedForPost;
  late final  String? postId;
  late final String? postUrl;
  late final String? profileImageForuserpost;
  late final  List? likes;

  SavePostModel({
    required this.useruidForPost,
    required this.savePostId,
    required this.currentUserId,
    required this.usernameForPost,
    required this.descriptionForPost,
    required this.datePublishedForPost,
    required this.postId,
    required this.postUrl,
    required this.profileImageForuserpost,
    required this.likes,
  });

  Map<String, dynamic> toSnapshot() =>
      {
        "useruidForPost": useruidForPost,
        "savePostId": savePostId,
        "currentUserId": currentUserId,
        "usernameForPost": usernameForPost,
        "descriptionForPost": descriptionForPost,
        "datePublishedForPost": datePublishedForPost,
        "postId": postId,
        "postUrl": postUrl,
        "profileImageForuserpost": profileImageForuserpost,
        "likes":likes
      };

  SavePostModel.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data() as Map<String, dynamic>;
    //PostModel(
    useruidForPost = result["useruidForPost"];
    savePostId= result["savePostId"];
    currentUserId = result["currentUserId"];
    usernameForPost = result["usernameForPost"];
    descriptionForPost = result["descriptionForPost"];
    datePublishedForPost = result["datePublishedForPost"];
    postId = result["postId"];
    postUrl = result["postUrl"];
    profileImageForuserpost = result["profileImageForuserpost"];
    likes = result['likes'];
    //);

  }
}
