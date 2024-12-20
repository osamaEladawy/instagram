import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/features/comments/cubit/comments_cubit.dart';
import 'package:inistagram/features/posts/screens/post.dart';
import 'package:inistagram/features/user/presentation/widgets/auth/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../shared/model/post_model.dart';
import 'commenet_card.dart';

class CommentPage extends StatefulWidget {
  final PostModel model;
  final QueryDocumentSnapshot postModel;
  final String userId;

  const CommentPage({
    super.key,
    required this.postModel,
    required this.userId,
    required this.model,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void dispose() {
    if (mounted) {
      CommentsCubit.instance.comment.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProviders>(context).users;

    return BlocConsumer<CommentsCubit, CommentsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
            bottomSheet: BottomSheet(
              backgroundColor: blackColor,
              onClosing: () {},
              builder: (BuildContext context) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage("${user!.imageUrl}"),
                      ),
                      Expanded(
                        child: CustomTextFormFieldPost(
                          controller: CommentsCubit.instance.comment,
                          hintText: "add Comment...",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await CommentsCubit.instance.addComment(
                              postId: "${widget.postModel['postId']}",
                              useruid: "${user.uid}",
                              username: "${user.username}",
                              profilePic: "${user.imageUrl}",
                              context: context,
                              postUrl: "${widget.postModel['postUrl']}",
                              postUserId: "${widget.postModel['uid']}");
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  PostPage(
                    postSnap: widget.model,
                    snapshot: widget.postModel,
                    isCommentPage: true,
                  ),
                  const Divider(),
                  StreamBuilder(
                    stream: CommentsCubit.instance
                        .getAllComments(widget.postModel['postId']),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return HandelRequest(
                        snapshot: snapshot,
                        widget: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot result =
                                  snapshot.data!.docs[index];
                              return CommentCard(
                                comSnap: result,
                                postSnap: widget.postModel,
                              );
                            }),
                      );
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
