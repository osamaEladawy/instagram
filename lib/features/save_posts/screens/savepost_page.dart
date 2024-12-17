import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/class/firestore_methods.dart';
import 'package:inistagram/core/functions/navigationpage.dart';
import 'package:inistagram/shared/model/save_posts.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/view_model/savepost/savePost_view_model.dart';
import 'package:inistagram/features/save_posts/screens/commentt_savepost.dart';
import 'package:inistagram/features/posts/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class SavePostPage extends StatefulWidget {
  final String postId;
  final String uid;
  const SavePostPage({
    super.key,
    required this.postId,
    required this.uid,
  });

  @override
  State<SavePostPage> createState() => _SavePostPageState();
}

class _SavePostPageState extends State<SavePostPage> {
  final SavePostViewModel _model =SavePostViewModel();

  getCountComments()async{
    _model.getCommentIndex(context, widget.postId);
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getCountComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProviders>(context).users;
    return Scaffold(
      appBar: AppBar(
        title: const Text("save post"),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("savePosts")
                .where("currentUserId", isEqualTo: widget.uid)
                .where("postId", isEqualTo: widget.postId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return HandelRequest(
                snapshot: snapshot,
                widget: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, left: 2, right: 2),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot snap = snapshot.data!.docs[index];
                      Map<String, dynamic> result =
                          snap.data() as Map<String, dynamic>;
                      SavePostModel savePost = SavePostModel.fromSnapshot(snap);
                      _model.time = result['datePublishedForPost'];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        "${savePost.profileImageForuserpost}"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("${savePost.usernameForPost}"),
                                ],
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: "Delete",
                                    child: user?.uid == savePost.useruidForPost
                                        ? const Text("Delete")
                                        : const Text("Cancel"),
                                  ),
                                ],
                                onSelected: (value) async {
                                  _model.newValue = value;
                                  setState(() {});
                                  if (_model.newValue == "Delete" &&
                                      savePost.currentUserId == user!.uid &&
                                      savePost.currentUserId ==
                                          savePost.useruidForPost) {
                                    _model.deletePosts(
                                        uid: savePost.useruidForPost!,
                                        postId: widget.postId,
                                        oldUrlImage: savePost.postUrl!,
                                        context: context);
                                  } else {
                                    print("no post delete from save posts");
                                  }
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
                                await FireStoreMethods().likeSavePost(
                                    user: "${user.toSnapshot()}",
                                    postId: "${savePost.postId}",
                                    likes: savePost.likes!,
                                    context: context,
                                    postUserId: "${savePost.useruidForPost}",
                                    postUrl: "${savePost.postUrl}",
                                    savePostId: '${savePost.savePostId}');
                                setState(() {
                                  _model.isAnimation = true;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width > 600
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.40
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.35,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      "${savePost.postUrl}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: _model.isAnimation ? 1 : 0,
                                    child: LikeAnimation(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      isAnimation: _model.isAnimation,
                                      callback: () {
                                        setState(() {
                                          _model.isAnimation = false;
                                        });
                                      },
                                      child: Icon(
                                        _model.isAnimation ? Icons.favorite : null,
                                        color: _model.isAnimation ? Colors.red : null,
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
                                      isAnimation: savePost.likes!
                                          .contains("${user.toSnapshot()}"),
                                      smallLike: true,
                                      child: IconButton(
                                        onPressed: () async {
                                          await FireStoreMethods().likeSavePost(
                                              user: "${user.toSnapshot()}",
                                              postId: "${savePost.postId}",
                                              likes: savePost.likes!,
                                              context: context,
                                              postUserId:
                                                  "${savePost.useruidForPost}",
                                              postUrl: "${savePost.postUrl}",
                                              savePostId:
                                                  '${savePost.savePostId}');
                                                 
                                        },
                                        icon: Icon(
                                            savePost.likes!.contains(
                                                    "${user.toSnapshot()}")
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: savePost.likes!.contains(
                                                    "${user.toSnapshot()}")
                                                ? Colors.red
                                                : Colors.white),
                                      ),
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      navigationPage(context, CommentSavePost(postData: savePost));
                                   
                                    },
                                    icon: const Icon(Icons.comment_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await FireStoreMethods()
                                          .shareImageUrl("${savePost.postUrl}");
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              if (user != null)
                                Row(
                                  children: [
                                    if (user.uid == savePost.currentUserId &&
                                        widget.postId == savePost.postId)
                                      //widget.postSnap['isSave'] == true
                                      IconButton(
                                        onPressed: () async {
                                          await _model.unSavePost(postId: savePost.postId!, context: context);
                                        },
                                        icon: Icon(user.uid ==
                                                    savePost.currentUserId &&
                                                widget.postId == savePost.postId
                                            ? Icons.bookmark
                                            : Icons.bookmark_outline),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    //if (savePost.likes!.isNotEmpty) {
                                    // showDialog(
                                    //  context: context,
                                    // builder: (context) {
                                    //   return Dialog(
                                    //     child: StreamBuilder(
                                    //       stream: model.getSinglePost(
                                    //           widget.postSnap['postId']),
                                    //       builder: (context,
                                    //           AsyncSnapshot<QuerySnapshot>
                                    //               snapshot) {
                                    //         return HandelRequest(
                                    //           snapshot: snapshot,
                                    //           widget: ListView.builder(
                                    //               shrinkWrap: true,
                                    //               itemCount: snapshot
                                    //                   .data?.docs.length,
                                    //               itemBuilder:
                                    //                   (context, index) {
                                    //                 DocumentSnapshot result =
                                    //                     snapshot.data!
                                    //                         .docs[index];
                                    //                 List likes =
                                    //                     result['likes'];
                                    //                 return ListView.builder(
                                    //                     shrinkWrap: true,
                                    //                     physics:
                                    //                         const NeverScrollableScrollPhysics(),
                                    //                     itemCount:
                                    //                         likes.length,
                                    //                     itemBuilder:
                                    //                         (context, index) {
                                    //                       String res =
                                    //                           likes[index]
                                    //                               .toString();
                                    //                       List convertToList =
                                    //                           res.split(' ');
                                    //                       print(
                                    //                           convertToList);
                                    //                       return Card(
                                    //                         child: ListTile(
                                    //                           leading:
                                    //                               CircleAvatar(
                                    //                             radius: 18,
                                    //                             backgroundImage:
                                    //                                 NetworkImage(
                                    //                                     convertToList[
                                    //                                         10]),
                                    //                           ),
                                    //                           title: Text(
                                    //                               "${convertToList[3]}"),
                                    //                           trailing:
                                    //                               MaterialButton(
                                    //                             color: Colors
                                    //                                 .blue,
                                    //                             onPressed:
                                    //                                 () {},
                                    //                             child: const Text(
                                    //                                 "follow"),
                                    //                           ),
                                    //                         ),
                                    //                       );
                                    //                     });
                                    //               }),
                                    //         );
                                    //       },
                                    //     ),
                                    //   );
                                    // });
                                    // }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (savePost.likes != null)
                                        Text(
                                            " ${savePost.likes!.length} Likes"),
                                      if (savePost.likes!.isNotEmpty)
                                        const Text(
                                          " show others",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${savePost.descriptionForPost}",
                                  style: const TextStyle(),
                                ),
                              ),
                            ],
                          ),
                          if (_model.show == false)
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {
                                      navigationPage(
                                        context,
                                        CommentSavePost(postData: savePost,
                                            ),
                                      );
                                    },
                                    child: Text(
                                      "view all ${_model.commentIndex} comments",
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    DateFormat.yMMMd().format(
                                        savePost.datePublishedForPost.toDate()),
                                  ), // 25 years ago
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Jiffy.parse(
                                            '${savePost.datePublishedForPost.toDate()}')
                                        .fromNow(),
                                  ), // 25 years ago
                                ),
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _model.show = !_model.show;
                                });
                              },
                              child: Text(
                                _model.show ? "show more" : "show less",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }),
      ),
    );
  }
}
