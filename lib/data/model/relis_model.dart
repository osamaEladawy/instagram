import 'package:cloud_firestore/cloud_firestore.dart';

class RilesModel {
  late final String? uid;
  late final String? username;
  late final  String? description;
  late final  datePublished;
  late final  String? rilesId;
  late final String? rilesUrl;
  late final String? profileImage;
  late final  List? likes;
  late final  List? share;
  late final  bool? isSave;

  RilesModel({
    required this.uid,
    required this.username,
    required this.description,
    required this.datePublished,
    required this.rilesId,
     required this.rilesUrl,
    required this.profileImage,
    required this.likes,
    required this.share,
    required this.isSave,
  });

  Map<String, dynamic> toSnapshot() =>
      {
        "uid": uid,
        "username": username,
        "description": description,
        "datePublished": datePublished,
        "rilesId": rilesId,
        "rilesUrl": rilesUrl,
        "profileImage": profileImage,
        "likes":likes,
        "share":share,
        "isSave":isSave,
      };

  RilesModel.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data() as Map<String, dynamic>;
    //PostModel(
    uid = result["uid"];
    username = result["username"];
    description = result["description"];
    datePublished = result["datePublished"];
    rilesId = result["rilesId"];
    rilesUrl = result["rilesUrl"];
    profileImage = result["profileImage"];
    likes = result['likes'];
    share = result['share'];
    isSave = result['isSave'];
    //);

  }
}
