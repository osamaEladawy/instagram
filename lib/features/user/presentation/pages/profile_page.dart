import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:inistagram/features/user/presentation/widgets/profile/appbartitle.dart';
import 'package:inistagram/features/user/presentation/widgets/profile/detialesForUsers.dart';
import 'package:inistagram/features/user/presentation/widgets/profile/tabsofposts.dart';
import 'package:inistagram/core/routes/page_const.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    info();
  }

  info() async {
    GetSingleUserCubit.instance.getSingleUser(userId: widget.uid);
    AuthCubit.instance.getData(context, widget.uid);
    AuthCubit.instance.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    var userEntity = Provider.of<UsersProviders>(context).users;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is GetDataForUsersLoading) {
          CircularProgressIndicator();
        } else if (state is GetPostsLoading) {
          CircularProgressIndicator();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pushNamedAndRemoveUntil(PageConst.initialPage);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            centerTitle: false,
            title: AppBarTitleForProfile(
              userEntity: userEntity,
            ),
            actions: [
              if (FirebaseAuth.instance.currentUser!.uid ==
                  AuthCubit.instance.userData['uid'])
                TextButton(
                    onPressed: () async {
                      await AuthCubit.instance.privateMyProfile(widget.uid);
                    },
                    child: AuthCubit.instance.value == true
                        ? const Text("public")
                        : const Text("private")),
              if (FirebaseAuth.instance.currentUser!.uid ==
                  AuthCubit.instance.userData['uid'])
                IconButton(
                  onPressed: () async {
                    await AuthCubit.instance.loggedOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
            child: Column(
              children: [
                DetailsForUser(
                  userEntity: userEntity!,
                  uid: widget.uid,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${AuthCubit.instance.userData['username']}"),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${AuthCubit.instance.userData['bio']}"),
                ),
                const Divider(),
                if (FirebaseAuth.instance.currentUser!.uid ==
                    AuthCubit.instance.userData['uid'])
                  TabsForPosts(
                    uid: widget.uid,
                    postId: AuthCubit.instance.post['postId'],
                  ),
                if (FirebaseAuth.instance.currentUser!.uid !=
                        AuthCubit.instance.userData['uid'] &&
                    AuthCubit.instance.isFollow == true &&
                    AuthCubit.instance.userData['isPrivate'] == false)
                  TabsForPosts(
                    uid: widget.uid,
                    postId: AuthCubit.instance.post["postId"],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
