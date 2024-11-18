import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/shared/model/post_model.dart';
import 'package:inistagram/views/post/post.dart';

class PostSActions extends StatefulWidget {
  final QueryDocumentSnapshot post;
  final String postId;
  final String message;

  const PostSActions(
      {super.key,
      required this.postId,
      required this.message,
      required this.post});

  @override
  State<PostSActions> createState() => _PostSActionsState();
}

class _PostSActionsState extends State<PostSActions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where("postId", isEqualTo: widget.postId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return HandelRequest(
                  snapshot: snapshot,
                  widget: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot result =
                            snapshot.data!.docs[index];
                        PostModel model = PostModel.fromSnapshot(result);
                        return PostPage(
                          postSnap: model, snapshot: result,
                          isCommentPage: false,
                          //index: index,
                        );
                      }),
                );
              },
            )),
      ),
    );
  }
}
