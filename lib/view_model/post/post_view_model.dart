import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/functions/navigationpage.dart';
import '../../core/class/firestore_methods.dart';
import '../../core/functions/snackbar.dart';
import 'package:path/path.dart' as Path;

class PostViewModel {
  FireStoreMethods storageMethod = FireStoreMethods();
  bool isIconChange = false;

  late Timestamp time;
  int commentIndex = 0;
  var newValue;
  bool save = false;
  bool isLike = false;

  List myActions = ["delete", "cancel"];
  bool show = true;
  bool isAnimation = false;

  var postLength = {};
  var userData = {};

  var likes = [];
  int likesLength = 0;
  bool isFollow = false;
  bool loading = false;
  var savePostData = {};
  var posts = {};

  getPosts() async {
    await FirebaseFirestore.instance.collection("posts").get().then((value) {
      value.docs.forEach((element) {
        posts = element.data();
      });
    });
    print("posts ===================================================");
    print(posts);
    print("posts ===================================================");
  }

  getSavePosts(postId) async {
    loading = true;
    await FirebaseFirestore.instance
        .collection("savePosts")
        .where("currentUserId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("postId", isEqualTo: postId)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        savePostData = element.data();

        print(
            "save posts =============================================savePostData");
        print(savePostData);
        print(
            "save posts =============================================savePostData");
      });
      loading = false;
    });
    loading = false;
  }

  getData(uid, context) async {
    loading = true;
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (FirebaseAuth.instance.currentUser != null &&
          userSnap.data() != null) {
        var currentUser = FirebaseAuth.instance.currentUser!.uid;
        userData = userSnap.data()!;
        isFollow = userSnap.data()!['followers'].contains(currentUser);
        print("===============================userData");
        print(userData);
        print("===============================userData");
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
    loading = false;
  }

  getCommentIndex(postId, context) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection('comments')
          .get();
      commentIndex = snapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  deletePosts(
      {required String uid,
      required String postId,
      required String oldUrlImage,
      required BuildContext context}) async {
    if (newValue == "Delete" && uid == FirebaseAuth.instance.currentUser?.uid) {
      try {
        FireStoreMethods().deletePost(uid, postId).then((value) {
          return deleteImage(oldUrlImage);
        }).then((value) {
          Future.delayed(const Duration(milliseconds: 500));
          navigationNamePage(context, PageConst.initialPage);
          return uid == FirebaseAuth.instance.currentUser?.uid
              ? showSnackBar("your post Deleting now",)
              : showSnackBar("this post Deleting now",);
        }).then((value) async {
          return await deleteSavePost(postId, context);
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
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
        .update({"isSave": false});
    //     .then((value) {
    //   Future.delayed(const Duration(milliseconds: 3000)).then((value) {
    //     return showSnackBar("post unSave now", context);
    //   });
    // });

    print("post save delete================================post");
  }

  likePosts(
      {required String user,
      required String postId,
      required List likes,
      required BuildContext context,
      required String postUserId,
      required String postUrl}) async {
    try {
      //isLike = true;
      FireStoreMethods().likePost(
          user: user,
          postId: postId,
          likes: likes,
          context: context,
          postUserId: postUserId,
          postUrl: postUrl);
      // navigationNamePage(context, PageConst.initialPage);
    } catch (e) {}
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSinglePost(postId) =>
      FirebaseFirestore.instance
          .collection("posts")
          .where("postId", isEqualTo: postId)
          .snapshots();

  IconData? iconOne({required void Function()? press}) {
    isIconChange = true;
    return Icons.bookmark;
  }

  IconData? icontow({required void Function()? press}) {
    isIconChange = false;
    return Icons.bookmark_outline_outlined;
  }

  saveMypost(
      {required String useruidForPost,
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
      context}) async {
    await storageMethod.savePost(
      useruidForPost: useruidForPost,
      currentUserId: currentUserId,
      usernameForPost: usernameForPost,
      descriptionForPost: descriptionForPost,
      postId: postId,
      postUrl: postUrl,
      profileImageForuserpost: profileImageForuserpost,
      likes: likes,
      currentUserIdFromDatabase: currentUserIdFromDatabase,
      postIdFromDatabase: postIdFromDatabase,
      datePublishedForPost: datePublishedForPost,
    );
  }
}
