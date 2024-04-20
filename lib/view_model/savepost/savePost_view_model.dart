import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/functions/firestore_methods.dart';
import 'package:path/path.dart' as Path;

import '../../core/shared/snackbar.dart';

class SavePostViewModel {
  TextEditingController text = TextEditingController();
  var dataComments = {};


  var newValue;
  bool isAnimation = false;
  bool show = false;
  late Timestamp time;
  int commentIndex = 0;

  unSavePost({required String postId,required BuildContext context})async{
    await FireStoreMethods().deleteSavePost(postId, context);
  }

  deletePosts(
      {required String uid,
        required String postId,
        required String oldUrlImage,
        required BuildContext context}) async {
    try {
      FireStoreMethods().deletePost(uid, postId).then((value) {
        return deleteImage(oldUrlImage);
      }).then((value) {
        Future.delayed(const Duration(milliseconds: 2000));
        return const Center(child: CircularProgressIndicator());
      }).then((value) {
        return FireStoreMethods().deleteSavePost(postId, context);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  getCommentIndex(context,postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection('comments')
          .get();
      commentIndex = snapshot.docs.length;
      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }


  getComments(savePostId) async {
    await FirebaseFirestore.instance
        .collection("savePosts")
        .doc(savePostId)
        .collection("comments")
        .get()
        .then((value) {
      for (var element in value.docs) {
        dataComments = element.data();
      }
      print("Comments==================================loaded");
      print(dataComments);
      print("Comments==================================loaded");
    });
  }

  addComment({
    required String postId,
    required String useruid,
    required String username,
    required String profilePic,
    required BuildContext context,
    required String postUrl,
    required String postUserId,
  }) async {
    try {
      await FireStoreMethods().postComment(
        postId: postId,
        text: text.text,
        useruid: useruid,
        username: username,
        profilePic: profilePic,
        context: context,
        postUrl: postUrl,
        postUserId: postUserId,
      );
      text.clear();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  deleteComment({
    required String postId,
    required String commentId,
    required String commentUserId,
    required String postUserId,
  }) async {
    try {
      await FireStoreMethods().deleteComment(
        postId: postId,
        commentId: commentId,
        commentUserId: commentUserId,
        postUserId: postUserId,
      );
    } catch (e) {}
  }

  likeComment({ required String userId,
    required String postId,
    required String commentId,
    required List likes,
    required BuildContext context,
    required String commentUserId,
    required String postUrl}) async {
    await FireStoreMethods().likeComment(
        userId: userId,
        postId: postId,
        commentId: commentId,
        likes: likes,
        context: context,
        commentUserId: commentUserId,
        postUrl: postUrl);
  }
}
