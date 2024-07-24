// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/controller/user_providers.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/functions/firestore_methods.dart';
import 'package:inistagram/view_model/post/post_view_model.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../../core/globel/functions/navigationpage.dart';
import '../../data/model/post_model.dart';
import '../comment/comment_page.dart';
import '../widgets/post/like_animation.dart';

class PostPage extends StatefulWidget {
  final PostModel postSnap;
  final QueryDocumentSnapshot snapshot;

  //final int index;

  const PostPage({
    super.key,
    required this.postSnap,
    required this.snapshot,
    //required this.index,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostViewModel model = PostViewModel();

  getMyPosts() async {
    await model.getPosts();
     if (mounted) {
      setState(() {});
    }
  }

  getAllCommentsIndex() async {
    await model.getCommentIndex(widget.postSnap.postId, context);
    if (mounted) {
      setState(() {});
    }
  }

  getAllData() async {
    await model.getData(widget.postSnap.uid, context);
    if (mounted) {
      setState(() {});
    }
  }

  getSaveMyPosts() async {
    await model.getSavePosts(widget.postSnap.postId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCommentsIndex();
    getAllData();
    getSaveMyPosts();
    getMyPosts();
    model.time = widget.postSnap.datePublished;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersProviders>(context).users;
    return FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.uid == widget.postSnap.uid ||
            model.isFollow && model.userData['isPrivate'] == false ||
            (MediaQuery.of(context).size.width > 600)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navigationNamePage(
                          context, PageConst.profilePage, widget.postSnap.uid
                          //model.userData['uid'],
                          );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage("${widget.postSnap.profileImage}"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("${widget.postSnap.username}"),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: "Delete",
                        child: Text("Delete"),
                      ),
                    ],
                    onSelected: (value) async {
                      model.newValue = value;
                      setState(() {});
                      model.deletePosts(
                          uid: widget.postSnap.uid!,
                          postId: widget.postSnap.postId!,
                          oldUrlImage: widget.postSnap.postUrl!,
                          context: context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (user != null)
                InkWell(
                  onDoubleTap: () async {
                    model.likePosts(
                        user: user.toSnapshot().toString(),
                        postId: widget.postSnap.postId!,
                        likes: widget.postSnap.likes!,
                        context: context,
                        postUserId: widget.postSnap.uid!,
                        postUrl: widget.postSnap.postUrl!);
                    setState(() {
                      model.isAnimation = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 600
                            ? MediaQuery.of(context).size.height * 0.40
                            : MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          "${widget.postSnap.postUrl}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: model.isAnimation ? 1 : 0,
                        child: LikeAnimation(
                          duration: Duration(milliseconds: 400),
                          isAnimation: model.isAnimation,
                          callback: () {
                            setState(() {
                              model.isAnimation = false;
                            });
                          },
                          child: Icon(
                            model.isAnimation ? Icons.favorite : null,
                            color: model.isAnimation ? Colors.red : null,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (user != null)
                        LikeAnimation(
                            isAnimation: widget.postSnap.likes!
                                .contains(user.toSnapshot().toString()),
                            smallLike: true,
                            child: IconButton(
                              onPressed: () async {
                                model.likePosts(
                                    user: user.toSnapshot().toString(),
                                    postId: widget.postSnap.postId!,
                                    likes: widget.postSnap.likes!,
                                    context: context,
                                    postUserId: widget.postSnap.uid!,
                                    postUrl: widget.postSnap.postUrl!);
                              },
                              icon: Icon(
                                  widget.postSnap.likes!.contains(
                                          user.toSnapshot().toString())
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.postSnap.likes!.contains(
                                          user.toSnapshot().toString())
                                      ? Colors.red
                                      : Colors.white),
                            )),
                      IconButton(
                        onPressed: () {
                          navigationPage(
                            context,
                            CommentPage(
                              postModel: widget.snapshot,
                              userId: "${model.userData['uid']}",
                              model: widget.postSnap,
                            ),
                          );
                        },
                        icon: const Icon(Icons.comment_outlined),
                      ),
                      IconButton(
                        onPressed: () async {
                          await FireStoreMethods()
                              .shareImageUrl("${widget.postSnap.postUrl}");
                        },
                        icon: const Icon(
                          Icons.send,
                          //color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (user != null)
                    //  user.uid == model.savePostData['currentUserId'] &&
                    //         widget.postSnap.postId ==
                    //             model.savePostData['postId'] &&
                            widget.postSnap.isSave == true
                        ? IconButton(
                            onPressed: () async {
                              await model.deleteSavePost(
                                  widget.postSnap.postId, context);
                            },
                            icon: Icon(Icons.bookmark))
                        : IconButton(
                            onPressed: () async {
                              return await model.saveMypost(
                                  useruidForPost: widget.postSnap.uid!,
                                  currentUserId: user.uid!,
                                  usernameForPost: widget.postSnap.username!,
                                  descriptionForPost:
                                      widget.postSnap.description!,
                                  postId: widget.postSnap.postId!,
                                  postUrl: widget.postSnap.postUrl!,
                                  profileImageForuserpost:
                                      widget.postSnap.profileImage!,
                                  likes: widget.postSnap.likes!,
                                  datePublishedForPost:
                                      widget.postSnap.datePublished,
                                  currentUserIdFromDatabase:
                                      model.savePostData['currentUserId'],
                                  postIdFromDatabase:
                                      model.savePostData['postId'],
                                  context: context);
                            },
                            icon: Icon(Icons.bookmark_outline),
                          ),
                ],
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if (widget.postSnap.likes!.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: StreamBuilder(
                                    stream: model
                                        .getSinglePost(widget.postSnap.postId),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      return HandelRequest(
                                        snapshot: snapshot,
                                        widget: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot result =
                                                  snapshot.data!.docs[index];
                                              PostModel postModel =
                                                  PostModel.fromSnapshot(
                                                      result);
                                              List likes = postModel.likes!;
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: likes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    String res =
                                                        likes[index].toString();
                                                    List convertToList =
                                                        res.split(' ');
                                                    print(convertToList);
                                                    return Card(
                                                      child: ListTile(
                                                          leading: CircleAvatar(
                                                            radius: 18,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    convertToList[
                                                                        10]),
                                                          ),
                                                          title: Text(
                                                              convertToList[3]),
                                                          trailing: (user
                                                                      ?.uid ==
                                                                  convertToList[
                                                                      1])
                                                              ? MaterialButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child:
                                                                      SizedBox(),
                                                                )
                                                              : MaterialButton(
                                                                  color: Colors
                                                                      .blue,
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "Follow"))),
                                                    );
                                                  });
                                            }),
                                      );
                                    },
                                  ),
                                );
                              });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.postSnap.likes != null)
                            Text(" ${widget.postSnap.likes!.length} Likes"),
                          if (widget.postSnap.likes!.isNotEmpty)
                            Text(
                              " show others",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        navigationPage(
                          context,
                          CommentPage(
                            postModel: widget.snapshot,
                            userId: "${model.userData['uid']}",
                            model: widget.postSnap,
                          ),
                        );
                      },
                      child: Text(
                        "view all ${model.commentIndex} comments",
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
              if (model.show == false)
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.postSnap.description}",
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat.yMMMd().format(model.time.toDate()),
                      ), // 25 years ago
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Jiffy.parse('${model.time.toDate()}').fromNow(),
                      ), // 25 years ago
                    ),
                  ],
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      model.show = !model.show;
                    });
                  },
                  child: Text(
                    model.show ? "more..." : "less",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
