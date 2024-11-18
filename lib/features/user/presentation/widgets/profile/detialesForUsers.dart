import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/features/chat/domain/entities/message_entity.dart';
import 'package:inistagram/features/user/domain/entities/user_entity.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/class/firestore_methods.dart';
import 'package:inistagram/core/functions/navigationpage.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/views/widgets/profile/follow_button.dart';

class DetailsForUser extends StatelessWidget {
  final UserEntity userEntity;
  final String uid;

  const DetailsForUser({
    super.key,
    required this.userEntity,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Row(
          children: [
            if (AuthCubit.instance.userData['imageUrl'] != null)
              CircleAvatar(
                radius: 35.r,
                backgroundImage:
                    NetworkImage("${AuthCubit.instance.userData['imageUrl']}"),
              ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContentColumn(
                          AuthCubit.instance.postLength, "Posts"),
                      buildContentColumn(
                          AuthCubit.instance.followers, "Followers"),
                      buildContentColumn(
                          AuthCubit.instance.following, "Following"),
                    ],
                  ),
                  if (FirebaseAuth.instance.currentUser!.uid !=
                      AuthCubit.instance.userData['uid'])
                    FollowButton(
                      onPressed: () {
                        navigationNamePage(
                          context,
                          PageConst.singleChatPage,
                          MessageEntity(
                            senderUid: userEntity.uid,
                            recipientUid: AuthCubit.instance.userData['uid'],
                            senderName: userEntity.username,
                            recipientName:
                                AuthCubit.instance.userData['username'],
                            senderProfile: userEntity.imageUrl,
                            recipientProfile:
                                AuthCubit.instance.userData["imageUrl"],
                            uid: userEntity.uid,
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
                      FirebaseAuth.instance.currentUser!.uid == uid
                          ? FollowButton(
                              onPressed: () {
                                navigationNamePage(context,
                                    PageConst.editProfilePage, userEntity);
                              },
                              backgroundColor: Colors.black,
                              borderColor: Colors.grey,
                              textColor: Colors.white,
                              text: 'Edit profile',
                            )
                          : AuthCubit.instance.isFollow
                              ? FollowButton(
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.grey,
                                  textColor: Colors.black,
                                  text: 'UnFollow',
                                  onPressed: () async {
                                    await FireStoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        AuthCubit.instance.userData['uid']);

                                    /// setState(() {
                                    AuthCubit.instance.isFollow = false;
                                    AuthCubit.instance.followers--;
                                    // });
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
                                        AuthCubit.instance.userData['uid']);
                                    // setState(() {
                                    AuthCubit.instance.isFollow = true;
                                    AuthCubit.instance.followers++;
                                    // });
                                  },
                                ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

Column buildContentColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
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
