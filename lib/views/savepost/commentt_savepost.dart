import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/core/shared/model/comment_save_post_model.dart';
import 'package:inistagram/core/shared/model/save_posts.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/view_model/savepost/savePost_view_model.dart';
import 'package:inistagram/views/widgets/auth/custom_textfield.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class CommentSavePost extends StatefulWidget {
  final SavePostModel postData;

  const CommentSavePost({super.key, required this.postData});

  @override
  State<CommentSavePost> createState() => _CommentSavePostState();
}

class _CommentSavePostState extends State<CommentSavePost> {
  final SavePostViewModel _model = SavePostViewModel();

  getComment() async {
    await _model.getComments(widget.postData.savePostId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getComment();
    super.initState();
  }

  @override
  void dispose() {
    _model.text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersProviders>(context).users;
    return Scaffold(
      appBar: AppBar(
        title: const Text("comment_save_post"),
      ),
      bottomSheet: BottomSheet(
        backgroundColor: blackColor,
        onClosing: () {},
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage("${user?.imageUrl}"),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: CustomTextFormFieldPost(
                  controller: _model.text,
                  hintText: "add comment",
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () async {
                  await _model.addComment(
                      postId: widget.postData.postId!,
                      useruid: user!.uid!,
                      username: user.username!,
                      profilePic: user.imageUrl!,
                      context: context,
                      postUrl: widget.postData.postUrl!,
                      postUserId: widget.postData.useruidForPost!);
                },
                child: const Text(
                  "Post",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postData.postId)
              .collection("comments")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return HandelRequest(
              snapshot: snapshot,
              widget: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot snap = snapshot.data!.docs[index];
                    CommentSavePostModel model =
                        CommentSavePostModel.fromSnapshot(snap);
                    return GestureDetector(
                      onLongPress: () async {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              alignment: Alignment.topCenter,
                              height: 200,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Are you sure you want to delete this comment",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await _model.deleteComment(
                                        postId: widget.postData.postId!,
                                        commentId: model.commentId!,
                                        commentUserId: model.useruid!,
                                        postUserId:
                                            widget.postData.useruidForPost!,
                                      );

                                      Navigator.of(context).maybePop();
                                    },
                                    child: const Text(
                                      "ok",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      "${model.profilePic}") //widget.postD,
                                  ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(snap['username']),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        Jiffy.parse(
                                                "${model.datePublished.toDate()}")
                                            .fromNow(),
                                      ),
                                    ],
                                  ),
                                  Text(model.text!),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  (user?.uid == model.useruid)
                                      ? GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            "Edit...",
                                            style:
                                                TextStyle(color: Colors.pink),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            "replay...",
                                            style:
                                                TextStyle(color: Colors.pink),
                                          ),
                                        ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _model.likeComment(
                                          userId: user!.toSnapshot().toString(),
                                          postId: widget.postData.postId!,
                                          commentId: model.commentId!,
                                          likes: model.likes!,
                                          context: context,
                                          commentUserId: model.useruid!,
                                          postUrl: widget.postData.postUrl!);
                                    },
                                    icon: Icon(
                                      model.likes!.contains(
                                              user?.toSnapshot().toString())
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: model.likes!.contains(
                                              user?.toSnapshot().toString())
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        // width: 20,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: Text(
                                            model.likes!.length.toString())),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
