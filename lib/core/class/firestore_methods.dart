import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inistagram/core/class/notification.dart';
import 'package:inistagram/core/class/storaged_method.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/core/storage/pref_services.dart';
import 'package:inistagram/shared/model/comment_model.dart';
import 'package:inistagram/shared/model/post_model.dart';
import 'package:inistagram/shared/model/relis_model.dart';
import 'package:inistagram/shared/model/save_posts.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FireStoreMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final MyNotification _notification = MyNotification();
  var data = {};
  var post = {};

  Future<String> uploadPost(String uid, File file, String description,
      String username, String profileImage, context) async {
    String res = "some error occurred";
    try {
      String photoUrl = await StorageMethod().uploadImage2("Posts", file, true);
      String postId = const Uuid().v1();

      PostModel postModel = PostModel(
        uid: uid,
        username: username,
        description: description,
        datePublished: DateTime.now(),
        postId: postId,
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
        isSave: false,
      );
      _store.collection("posts").doc(postId).set(postModel.toSnapshot());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadRiles(
      {required String uid,
      required String username,
      required String description,
      required String profileImage,
      required File file}) async {
    String res = "some error occurred";

    String rilesUrl = await StorageMethod().uploadVideo(
      "Riles",
      file,
      false,
    );

    final collectionReference = _store.collection("Riles");

    final rilesId = collectionReference.doc().id;

    final riles = RilesModel(
      uid: uid,
      username: username,
      description: description,
      datePublished: DateTime.now(),
      rilesId: rilesId,
      rilesUrl: rilesUrl,
      profileImage: profileImage,
      likes: [],
      share: [],
      isSave: false,
    ).toSnapshot();

    try {
      collectionReference.doc(rilesId).get().then((value) {
        if (!value.exists) {
          collectionReference.doc(rilesId).set(riles);
          res = "success";
        } else {}
      });
    } catch (e) {
      res = e.toString();
      throw Exception(e.toString());
    }
    return res;
  }

  Future<void> likePost(
      {required String user,
      required String postId,
      required List likes,
      required BuildContext context,
      required String postUserId,
      required String postUrl}) async {
    try {
      // final newUser = UserModel(
      //     uid: user.uid,
      //     username: user.username,
      //     email: user.email,
      //     bio: user.bio,
      //     imageUrl: user.imageUrl,
      //     following: user.following,
      //     followers: user.followers,
      //     saves: user.saves,
      //     isOnline: user.isOnline,
      //     dateWhenLogOut: user.dateWhenLogOut,
      //     isPrivate: user.isPrivate).toSnapshot();

      if (likes.contains(user)) {
        await _store.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([user])
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("savePosts")
              .where("postId", isEqualTo: postId)
              .where("currentUserId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            print(
                "remove like post ================================remove like post");

            value.docs.forEach((element) async {
              var dataForPost = element.data();

              String document = dataForPost['savePostId'];

              print(
                  "like waitting================================ like waitting");

              await FirebaseFirestore.instance
                  .collection("savePosts")
                  .doc(document)
                  .update({
                "likes": FieldValue.arrayRemove([user])
              });
              print("remove like post in saves ===========================");
            });
          });
        });
      } else {
        await _store.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([user])
        }).then((value) async {
          final users =
              Provider.of<UsersProviders>(context, listen: false).users;
          if (users != null && PrefServices.getData(key: 'uid') != null) {
            await _store
                .collection("users")
                .doc(users.uid)
                .get()
                .then((value) async {
              if (value.data() != null) {
                var dataForUser = value.data()!;

                String userId = PrefServices.getData(key: 'uid')!;

                if (userId != postUserId) {
                  await _notification.sendNotificationWithTopic(
                      title: "Hello ${users.username}",
                      message:
                          "your friend ${dataForUser['username']} like your post",
                      topic: "users$userId",
                      data: data);

                  var snap = _store
                      .collection("users")
                      .doc(postUserId)
                      .collection("notifications");
                  var docRef = snap.doc();
                  docRef.set({
                    "notificationUid": docRef.id,
                    "uid": dataForUser['uid'],
                    "username": dataForUser['username'],
                    "imageUrl": dataForUser['imageUrl'],
                    "postId": postId,
                    "message":
                        "your friend ${dataForUser['username']} like your post",
                    "postUrl": postUrl
                  });
                }
              }
            });
          }
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("savePosts")
              .where("postId", isEqualTo: postId)
              .where("currentUserId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            value.docs.forEach((element) async {
              var dataForPost = element.data();

              String document = dataForPost['savePostId'];

              print(
                  "like post now================================ like post now");

              await FirebaseFirestore.instance
                  .collection("savePosts")
                  .doc(document)
                  .update({
                "likes": FieldValue.arrayUnion([user])
              });
              print("like post in saves ===========================");
            });
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeSavePost(
      {required String user,
      required String savePostId,
      required String postId,
      required List likes,
      required BuildContext context,
      required String postUserId,
      required String postUrl}) async {
    try {
      if (likes.contains(user)) {
        await _store.collection("savePosts").doc(savePostId).update({
          "likes": FieldValue.arrayRemove([user])
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("posts")
              .where("postId", isEqualTo: postId)
              // .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            print(
                "remove like post ================================remove like post");

            value.docs.forEach((element) async {
              var dataForPost = element.data();

              String document = dataForPost['postId'];

              print(
                  "like waitting================================ like waitting");

              await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(document)
                  .update({
                "likes": FieldValue.arrayRemove([user])
              });
              print("remove like post in saves ===========================");
            });
          });
        });
      } else {
        await _store.collection("savePosts").doc(savePostId).update({
          "likes": FieldValue.arrayUnion([user])
        }).then((value) async {
          final users =
              Provider.of<UsersProviders>(context, listen: false).users;
          if (users != null && PrefServices.getData(key: 'uid') != null) {
            await _store
                .collection("users")
                .doc(users.uid)
                .get()
                .then((value) async {
              if (value.data() != null) {
                var dataForUser = value.data()!;

                String userId = PrefServices.getData(key: 'uid')!;

                if (userId != postUserId) {
                  await _notification.sendNotificationWithTopic(
                      title: "Hello ${users.username}",
                      message:
                          "your friend ${dataForUser['username']} like your post",
                      topic: "users$userId",
                      data: data);

                  var snap = _store
                      .collection("users")
                      .doc(postUserId)
                      .collection("notifications");
                  var docRef = snap.doc();
                  docRef.set({
                    "notificationUid": docRef.id,
                    "uid": dataForUser['uid'],
                    "username": dataForUser['username'],
                    "imageUrl": dataForUser['imageUrl'],
                    "postId": postId,
                    "message":
                        "your friend ${dataForUser['username']} like your post",
                    "postUrl": postUrl
                  });
                }
              }
            });
            print("send notification============================= ");
          }
        }).then((value) async {
          await _store
              .collection("posts")
              .where("postId", isEqualTo: postId)
              //.where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            value.docs.forEach((element) async {
              var dataForPost = element.data();

              String document = dataForPost['postId'];

              print(
                  "like post now================================ like post now");

              await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(document)
                  .update({
                "likes": FieldValue.arrayUnion([user])
              });
              print("like post in saves ===========================");
            });
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(
      {required String userId,
      required String postId,
      required String commentId,
      required List likes,
      required BuildContext context,
      required String commentUserId,
      required String postUrl}) async {
    try {
      if (likes.contains(userId)) {
        await _store
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([userId])
        });
      } else {
        await _store
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([userId])
        });
        final users = Provider.of<UsersProviders>(context, listen: false).users;
        if (users != null && PrefServices.getData(key: 'uid') != null) {
          var userSnap = await _store.collection("users").doc(users.uid).get();
          if (userSnap.data() != null) {
            data = userSnap.data()!;
          }
          String userId = PrefServices.getData(key: 'uid')!;
          if (userId != commentUserId) {
            await _notification.sendNotificationWithTopic(
                title: "Hello ${users.username}",
                message: "your friend ${data['username']} like your comment",
                topic: "users",
                data: data);
            var snap = _store
                .collection("users")
                .doc(commentUserId)
                .collection("notifications");
            var docRef = snap.doc();
            docRef.set({
              "notificationUid": docRef.id,
              "uid": data['uid'],
              "username": data['username'],
              "imageUrl": data['imageUrl'],
              "postId": postId,
              "message": "your friend ${data['username']} like your comment",
              "postUrl": postUrl
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComment({
    required String postId,
    required String text,
    required String useruid,
    required String username,
    required String profilePic,
    required BuildContext context,
    required String postUrl,
    required String postUserId,
  }) async {
    if (text.isNotEmpty && PrefServices.getData(key: 'uid') != null) {
      try {
        final collectionRef =
            _store.collection("posts").doc(postId).collection("comments");

        String commentId = collectionRef.doc().id;

        final newComments = CommentModel(
          useruid: useruid,
          username: username,
          profilePic: profilePic,
          datePublished: DateTime.now(),
          text: text,
          commentId: commentId,
          postId: postId,
          likes: [],
        ).toSnapshot();

        await _store
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(newComments)
            .then((value) async {
          final users =
              Provider.of<UsersProviders>(context, listen: false).users;

          if (users != null && PrefServices.getData(key: 'uid') != null) {
            await _store
                .collection("users")
                .doc(users.uid)
                .get()
                .then((value) async {
              if (value.data() != null) {
                var dataForUser = value.data()!;

                String userId = PrefServices.getData(key: 'uid')!;

                if (userId != postUserId) {
                  await _notification.sendNotificationWithTopic(
                      title: "Hello ${users.username}",
                      message:
                          "your friend ${dataForUser['username']} commented your post",
                      topic: "users$userId",
                      data: data);

                  var snap = _store
                      .collection("users")
                      .doc(postUserId)
                      .collection("notifications");
                  var docRef = snap.doc();
                  docRef.set({
                    "notificationUid": docRef.id,
                    "uid": dataForUser['uid'],
                    "username": dataForUser['username'],
                    "imageUrl": dataForUser['imageUrl'],
                    "postId": postId,
                    "message":
                        "your friend ${dataForUser['username']} commented your post",
                    "postUrl": postUrl
                  });
                }
              }
            });
          }
          print("send notifications for user ============================");
        });
        //     .then((value) async {
        //   await _store
        //       .collection("savePosts")
        //       .where("postId", isEqualTo: postId)
        //       .get()
        //       .then((value) async {
        //     value.docs.forEach((element) async {
        //       var savePostData = element.data()!;
        //       String savepostUid = savePostData['savePostId'];
        //       print(
        //           "add comment to save  post watting ============================");
        //       final collectionRef = _store
        //           .collection("savePosts")
        //           .doc(savepostUid)
        //           .collection("comments");
        //
        //       final document = collectionRef.doc();
        //
        //       await document.set({
        //         "commentSavePostId": document.id,
        //         "useruid": useruid,
        //         "username": username,
        //         "profilePic": profilePic,
        //         "datePublished": DateTime.now(),
        //         "text": text,
        //         "commentId": commentId,
        //         "postId": postId,
        //         "likes": [],
        //       });
        //
        //       print(
        //           "add comment to save post  ============================done");
        //     });
        //   });
        // });
      } catch (e) {
        print(e.toString());
      }
    } else {
      print("Text is empty");
    }
  }

  Future<void> editComment(String newText, String postId, String commentId,
      String commentUserId) async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (currentUser == commentUserId) {
      try {
        return await _store
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "text": newText,
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> deletePost(String userId, String postId) async {
    if (FirebaseAuth.instance.currentUser!.uid == userId) {
      try {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .delete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteComment(
      {required String postId,
      required String commentId,
      required String commentUserId,
      required String postUserId}) async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (currentUser == commentUserId || currentUser == postUserId) {
      try {
        await _store
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .delete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _store.collection("users").doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        _store.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });
        _store.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId]),
        });
      } else {
        _store.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });
        _store.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> savePost({
    required String useruidForPost,
    required String currentUserId,
    required String usernameForPost,
    required String descriptionForPost,
    datePublishedForPost,
    required String postId,
    required String postUrl,
    required String profileImageForuserpost,
    required List likes,
    currentUserIdFromDatabase,
    postIdFromDatabase,
  }) async {
    final collectionReference = _store.collection("savePosts");

    final savePostId = collectionReference.doc().id;

    final savePost = SavePostModel(
            useruidForPost: useruidForPost,
            savePostId: savePostId,
            currentUserId: currentUserId,
            usernameForPost: usernameForPost,
            descriptionForPost: descriptionForPost,
            datePublishedForPost: datePublishedForPost,
            postId: postId,
            postUrl: postUrl,
            profileImageForuserpost: profileImageForuserpost,
            likes: likes)
        .toSnapshot();

    try {
      collectionReference.doc(savePostId).get().then((value) async {
        if (!value.exists) {
          collectionReference.doc(savePostId).set(savePost);
          await _store.collection("posts").doc(postId).update({"isSave": true});

          print("post save set================================post");
        } else {}
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  deleteSavePost(postId, context) async {
    await FirebaseFirestore.instance
        .collection("savePosts")
        .where("currentUserId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("postId", isEqualTo: postId)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        var postSave = element.data();
        String savePostId = postSave['savePostId'];

        await FirebaseFirestore.instance
            .collection("savePosts")
            .doc(savePostId)
            .delete();
      });
    });
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .update({"isSave": false}).then((value) {
      Future.delayed(const Duration(milliseconds: 3000)).then((value) {
        return showSnackBar("post unSave now");
      });
    });

    print("post save delete================================post");
  }

  savePosts({
    required String useruidForPost,
    required String currentUserId,
    required String usernameForPost,
    required String descriptionForPost,
    datePublishedForPost,
    required String postId,
    required String postUrl,
    required String profileImageForuserpost,
    required List likes,
    required currentUserIdFromDatabase,
    required postIdFromDatabase,
  }) async {
    final collectionReference = _store.collection("savePosts");

    final savePostId = collectionReference.doc().id;

    final savePost = SavePostModel(
            useruidForPost: useruidForPost,
            savePostId: savePostId,
            currentUserId: currentUserId,
            usernameForPost: usernameForPost,
            descriptionForPost: descriptionForPost,
            datePublishedForPost: datePublishedForPost,
            postId: postId,
            postUrl: postUrl,
            profileImageForuserpost: profileImageForuserpost,
            likes: likes)
        .toSnapshot();

    try {
      collectionReference.doc(savePostId).get().then((value) async {
        if (!value.exists) {
          if (FirebaseAuth.instance.currentUser!.uid ==
                  currentUserIdFromDatabase &&
              postId == postIdFromDatabase) {
            await FirebaseFirestore.instance
                .collection("savePosts")
                .where("currentUserId",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("postId", isEqualTo: postId)
                .get()
                .then((value) {
              value.docs.forEach((element) async {
                var postSave = element.data();
                String documentId = postSave['savePostId'];

                await FirebaseFirestore.instance
                    .collection("savePosts")
                    .doc(documentId)
                    .delete();
              });
            });

            await _store
                .collection("posts")
                .doc(postId)
                .update({"isSave": false});

            print("post save delete================================post");
          } else {
            collectionReference.doc(savePostId).set(savePost);
            await _store
                .collection("posts")
                .doc(postId)
                .update({"isSave": true});

            print("post save set================================post");
          }
        } else {}
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  removeMapFromFirebase(
      String documentId, Map<String, dynamic> mapToRemove) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .update({
      'likes': FieldValue.arrayRemove([mapToRemove])
    });
  }

  Future<void> shareImage(String postUrl) async {
    final response = await http.get(Uri.parse(postUrl));
    final bytes = response.bodyBytes;
    final temp = (await getTemporaryDirectory());
    final path = "${temp.path}/image.jpg";
    final res = File(path).writeAsBytesSync(bytes);
    // await Share.shareXFiles(
    //   [path],
    //   text: "Hello users",
    // );
  }

  Future<void> shareImageUrl(String postUrl) async {
    // const url = "https://www.youtube.com/shorts/6NGosFgx45Y";
    await Share.share(postUrl);
  }

  Future<void> shareImageFromGalleryOrCamera() async {
    XFile? url = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (url == null) return;
    await Share.shareXFiles([url]);
    // final result = await FilePicker.platform.pickFiles(type: FileType.image);
    // final response = result?.files.map((file) => file.path).toList();
    // if(response == null) return;
    //await Share.shareFiles(response);
  }
}
