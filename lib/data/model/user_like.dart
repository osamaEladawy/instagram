import 'package:cloud_firestore/cloud_firestore.dart';

class UserLike {
  late final String? userId;
  late final String? username;
  late final String? imageUrl;

  UserLike({
    required this.userId,
    required this.username,
    required this.imageUrl,
    });

  Map<String, dynamic> toSnapshot() =>
      {
        "uid": userId,
        "username": username,
        "imageUrl": imageUrl,
      };

    UserLike.fromSnapshot(DocumentSnapshot snapshot) {
    var result = snapshot.data()! as Map<String, dynamic>;
      // UserModel(
        userId = result["uid"];
        username = result["username"];
        imageUrl = result["imageUrl"];
    //);

  }
}
