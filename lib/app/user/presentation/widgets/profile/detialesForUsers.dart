import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/app/chat/domain/entities/message_entity.dart';
import 'package:inistagram/app/user/domain/entities/user_entity.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/functions/firestore_methods.dart';
import 'package:inistagram/core/globel/functions/navigationpage.dart';
import 'package:inistagram/view_model/profile/profile_view_model.dart';
import 'package:inistagram/views/widgets/profile/follow_button.dart';

class DetialesForUser extends StatefulWidget {
  final ProfileViewModel model;
  final UserEntity userEntity;
  final String uid;

  const DetialesForUser(
      {super.key,
      required this.model,
      required this.userEntity,
      required this.uid});

  @override
  State<DetialesForUser> createState() => _DetialesForUserState();
}

class _DetialesForUserState extends State<DetialesForUser> {
  Column buildContentColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.model.userData['imageUrl'] != null)
          CircleAvatar(
            radius: 35,
            backgroundImage:
                NetworkImage("${widget.model.userData['imageUrl']}"),
          ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContentColumn(widget.model.postLength, "Posts"),
                  buildContentColumn(widget.model.followers, "Followers"),
                  buildContentColumn(widget.model.following, "Following"),
                ],
              ),
              if (FirebaseAuth.instance.currentUser!.uid !=
                  widget.model.userData['uid'])
                FollowButton(
                  onPressed: () {
                      navigationNamePage(
                        context,
                        PageConst.singleChatPage,
                        MessageEntity(
                          senderUid: widget.userEntity.uid,
                          recipientUid: widget.model.userData['uid'],
                          senderName: widget.userEntity.username,
                          recipientName: widget.model.userData['username'],
                          senderProfile: widget.userEntity.imageUrl,
                          recipientProfile: widget.model.userData["imageUrl"],
                          uid: widget.userEntity.uid,
                        ),
                      );
                  },
                  backgroundColor: Colors.black,
                  borderColor: Colors.grey,
                  textColor: const Color.fromARGB(255, 105, 49, 49),
                  text: 'Message',
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? FollowButton(
                          onPressed: () {
                            navigationNamePage(context,
                                PageConst.editProfilePage, widget.userEntity);
                          },
                          backgroundColor: Colors.black,
                          borderColor: Colors.grey,
                          textColor: Colors.white,
                          text: 'Edit profile',
                        )
                      : widget.model.isFollow
                          ? FollowButton(
                              backgroundColor: Colors.white,
                              borderColor: Colors.grey,
                              textColor: Colors.black,
                              text: 'UnFollow',
                              onPressed: () async {
                                await FireStoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.model.userData['uid']);
                                setState(() {
                                  widget.model.isFollow = false;
                                  widget.model.followers--;
                                });
                              },
                            )
                          : FollowButton(
                              backgroundColor: Colors.blue,
                              borderColor: Colors.blue,
                              textColor: Colors.white,
                              text: 'Follow',
                              onPressed: () async {
                                await FireStoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.model.userData['uid']);
                                setState(() {
                                  widget.model.isFollow = true;
                                  widget.model.followers++;
                                });
                              },
                            ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
