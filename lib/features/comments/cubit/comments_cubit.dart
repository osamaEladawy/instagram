import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/class/firestore_methods.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/my_app.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(CommentsInitial());

  static final CommentsCubit _commentsCubit =
      BlocProvider.of(navigatorKey.currentContext!);
  static CommentsCubit get instance => _commentsCubit;

  final TextEditingController comment = TextEditingController();

  final myKey = GlobalKey<FormState>();

  late String newValue;

  late Timestamp _time;

  Timestamp get time => _time;

  set time(Timestamp time) => _time = time;

  int commentIndex = 0;
  List<String> myLike = [];
  var userData = {};

  // editComments({postId, commentId, uid, userNameComment, context}) async {
  //   await FireStoreMethods()
  //       .editComment(_commentController.text, postId, commentId, uid)
  //       .then((value) {
  //     showSnackBar("$userNameComment", context);
  //     _commentController.clear();
  //     Navigator.of(context).pop();
  //   });
  // }

  deleteComments({
    required String postId,
    required String commentId,
    required String commentUserId,
    required String postUserId,
    required String usernameComment,
    required BuildContext context,
  }) async {
    await FireStoreMethods()
        .deleteComment(
            postId: postId,
            commentId: commentId,
            commentUserId: commentUserId,
            postUserId: postUserId)
        .then((value) {
      if (FirebaseAuth.instance.currentUser!.uid == commentUserId) {
        //showSnackBar("you deleted This post", context);
        Navigator.of(context).maybePop();
      } else {
        showSnackBar("$usernameComment deleted This post");
        Navigator.of(context).maybePop();
      }
    });
  }

  addComment({
    required BuildContext context,
    required String useruid,
    required String postId,
    required String postUserId,
    required String postUrl,
    required String profilePic,
    required String username,
  }) async {
    if (comment.text.isNotEmpty) {
      await FireStoreMethods().postComment(
        postUserId: postUserId,
        postUrl: postUrl,
        postId: postId,
        profilePic: profilePic,
        text: comment.text,
        useruid: useruid,
        username: username,
        context: context,
      );
      comment.clear();
    } else {
      showSnackBar("Please Enter the comment");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments(String postId) =>
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection("comments")
          .orderBy("datePublished", descending: true)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCommentsDocuments(
          String postId, String commentId) =>
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection("comments")
          .where("commentId", isEqualTo: commentId)
          .snapshots();
}
