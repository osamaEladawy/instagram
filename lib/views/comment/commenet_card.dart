import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/functions/firestore_methods.dart';
import 'package:inistagram/main.dart';
import 'package:inistagram/view_model/comment/comment_view_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../controller/user_providers.dart';
import '../widgets/auth/custom_dialog.dart';
import '../widgets/post/like_animation.dart';

class CommentCard extends StatefulWidget {
  final QueryDocumentSnapshot comSnap;
  final QueryDocumentSnapshot postSnap;

  const CommentCard({
    super.key,
    required this.comSnap,
    required this.postSnap,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final CommentViewModel _model = CommentViewModel();

  @override
  void initState() {
    _model.time = widget.comSnap['datePublished'];
    // _model.commentController.text = widget.comSnap['text'];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //_model.commentController.dispose();
    _model.comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProviders>(context).users;
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => DialogForPassword(
            content: 'Are you sure delete your comment',
            onPressed: () async {
              await _model.deleteComments(
                postId: widget.postSnap['postId'],
                commentId: widget.comSnap['commentId'],
                commentUserId: widget.comSnap['useruid'],
                usernameComment: widget.comSnap['username'],
                context: context,
                postUserId: widget.postSnap['uid'],
              );
              Navigator.of(context).maybePop();
            },
            onCancle: () {
              Navigator.of(context).maybePop();
            },
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.comSnap['profilePic']),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.comSnap['username']),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Jiffy.parse("${_model.time.toDate()}").fromNow(),
                      )
                    ],
                  ),
                  Text(
                    " ${widget.comSnap["text"]}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 7,),
                  user!.uid != widget.comSnap['useruid']
                      ? GestureDetector(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         alignment: Alignment.bottomCenter,
                            //         content: Form(
                            //           child: Stack(
                            //             clipBehavior: Clip.none,
                            //             children: [
                            //               TextFormField(
                            //                 maxLines: null,
                            //                 decoration: const InputDecoration(),
                            //               ),
                            //               Positioned(
                            //                 right: 0,
                            //                 bottom: 0,
                            //                 child: TextButton(
                            //                     onPressed: () {},
                            //                     child: const Text("post")),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     });
                          },
                          child: const Text(
                            "replay",
                            style: TextStyle(color: Colors.pink),
                          ),
                        )
                      : GestureDetector(
                          child: const Text(
                            "Edit...",
                            style:
                                TextStyle(fontSize: 15.5, color: Colors.pink),
                          ),
                          onTap: () async {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => Dialog(
                            //           alignment: Alignment.bottomCenter,
                            //           child: Card(
                            //             child: Form(
                            //               child: Stack(
                            //                 clipBehavior: Clip.none,
                            //                 children: [
                            //                   TextFormField(
                            //                     maxLines: null,
                            //                     controller:
                            //                         _model.commentController,
                            //                     decoration: InputDecoration(
                            //                       hintText:
                            //                           widget.comSnap['text'],
                            //                       border:
                            //                           const OutlineInputBorder(
                            //                         borderRadius:
                            //                             BorderRadius.all(
                            //                           Radius.circular(25),
                            //                         ),
                            //                         borderSide: BorderSide(
                            //                             color:
                            //                                 Colors.transparent),
                            //                       ),
                            //                       enabledBorder:
                            //                           const OutlineInputBorder(
                            //                         borderRadius:
                            //                             BorderRadius.all(
                            //                           Radius.circular(25),
                            //                         ),
                            //                         borderSide: BorderSide(
                            //                             color:
                            //                                 Colors.transparent),
                            //                       ),
                            //                       filled: true,
                            //                     ),
                            //                     onChanged: (value) {
                            //                       if (value.isNotEmpty) {
                            //                         _model.newValue = value;
                            //                         setState(() {});
                            //                       }
                            //                     },
                            //                   ),
                            //                   Positioned(
                            //                     bottom: 0,
                            //                     right: 0,
                            //                     child: TextButton(
                            //                       onPressed: () async {
                            //                         await _model.editComments(
                            //                           postId: widget
                            //                               .postSnap['postId'],
                            //                           commentId: widget
                            //                               .comSnap['commentId'],
                            //                           uid:
                            //                               widget.comSnap['uid'],
                            //                           userNameComment: widget
                            //                               .comSnap['name'],
                            //                           context: context,
                            //                         );
                            //                       },
                            //                       child: const Text("post"),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ));
                          },
                        ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  LikeAnimation(
                    isAnimation: widget.comSnap['likes']
                        .contains("${user.toSnapshot()}"),
                    smallLike: true,
                    child: IconButton(
                      onPressed: () async {
                        await FireStoreMethods().likeComment(
                            userId: "${user.toSnapshot()}",
                            postId: widget.postSnap['postId'],
                            commentId: widget.comSnap['commentId'],
                            likes: widget.comSnap['likes'],
                            context: context,
                            commentUserId: "${widget.comSnap['useruid']}",
                            postUrl: "${widget.postSnap['postUrl']}");
                      },
                      icon: Icon(
                          widget.comSnap['likes']!
                                  .contains("${user.toSnapshot()}")
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.comSnap['likes']!
                                  .contains("${user.toSnapshot()}")
                              ? Colors.red
                              : Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.comSnap["likes"].isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: StreamBuilder(
                                  stream: _model.getAllCommentsDocuments(
                                      widget.postSnap['postId'],
                                      widget.comSnap['commentId']),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    return HandelRequest(
                                      snapshot: snapshot,
                                      widget: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot result =
                                                snapshot.data!.docs[index];
                                            List likes = result['likes'];
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: likes.length,
                                                itemBuilder: (context, index) {
                                                  String res =
                                                      likes[index].toString();
                                                  List convertToList =
                                                      res.split(' ');
                                                  String getUsers = preferences
                                                      .getString('uid')!;
                                                  return Card(
                                                    child: ListTile(
                                                      onTap: () {},
                                                      leading: CircleAvatar(
                                                        radius: 18,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${convertToList[10]}"),
                                                      ),
                                                      title: Text(
                                                          convertToList[3]
                                                              .toString()),
                                                      trailing: MaterialButton(
                                                        color: Colors.blue,
                                                        onPressed: () {},
                                                        child:
                                                            convertToList[1] !=
                                                                    getUsers
                                                                ? const Text(
                                                                    "follow")
                                                                : null,
                                                      ),
                                                    ),
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
                    child: Text("${widget.comSnap['likes'].length}"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
