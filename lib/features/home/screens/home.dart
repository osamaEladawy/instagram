import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:inistagram/features/status/presentation/pages/status_page.dart';
import 'package:inistagram/shared/model/post_model.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/features/user/presentation/widgets/auth/dialog.dart';
import 'package:provider/provider.dart';
import '../../../core/class/handel_request.dart';
import '../../../core/const/page_const.dart';
import '../../../core/class/notification.dart';
import '../../../core/functions/navigationpage.dart';
import '../../../core/class/share_data.dart';
import '../../../view_model/home/home_view_model.dart';
import '../../posts/screens/post.dart';
// import 'package:flutter_offline/flutter_offline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel model = HomeViewModel();

  getMyUsers() async {
    await model.getUsers(context, FirebaseAuth.instance.currentUser!.uid);
    if (context.mounted) {
      setState(() {});
    }
  }

  getMyToken() async {
    print("==================================token");
    await MyNotification().getToken();
    print("==================================token");
  }

  getSaveMyPosts() async {
    await model.getSavePosts();
    if (context.mounted) {
      setState(() {});
    }
  }

  getMyPosts() async {
    await model.getPosts();
    if (mounted) {
      setState(() {});
    }
  }

  getMyPermission() async {
    await MyNotification().myPermission();
  }

  getMygetInitialMessage() async {
    await MyNotification().getInitialMessage(context);
  }

  @override
  void initState() {
    super.initState();
    getMyToken();
    if (context.mounted) {
      getSaveMyPosts();
      getMyPosts();
      getMyPermission();
      getMygetInitialMessage();
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('====================ForGround================');

        if (mounted) {
          // showSnackBar("${message.notification!.body}", context);
        }
      }
    });
    //model.notificationOnMessage(context);
    //  model.notificationWhenOpenApp();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "========================================================> Text Message");
      if (message.data['type'] == 'none') {
        print(
            "========================================================> Text Message Done");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersProviders>(context).users;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instagram"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Badge(
              backgroundColor: Colors.red,
              label: Text("1"),
              child: IconButton(
                onPressed: () {
                  navigationNamePage(context, PageConst.notifications);
                },
                icon: const Icon(Icons.favorite),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () {
                navigationNamePage(context, PageConst.chatPage, '${user!.uid}');
              },
              icon: const Icon(Icons.comment_outlined),
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          showDialog(context: context, builder: (context) => const MyDialog());
        },
        child: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              List<ConnectivityResult> value, Widget child) {
            final bool connect = value != ConnectivityResult.none;
            if (connect) {
              return CustomScrollView(
                slivers: [
                  if (user != null)
                    SliverToBoxAdapter(
                      child: StatusPage(
                        currentUser: user,
                      ),
                    ),
                  SliverToBoxAdapter(child: const Divider()),
                  SliverToBoxAdapter(
                    child: StreamBuilder(
                      stream: model.getAllPosts(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return HandelRequest(
                          snapshot: snapshot,
                          widget: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot result =
                                    snapshot.data!.docs[index];
                                PostModel model =
                                    PostModel.fromSnapshot(result);
                                return Container(
                                  padding:
                                      SharedData().currentWidth(context) > 600
                                          ? const EdgeInsets.all(20)
                                          : const EdgeInsets.all(8),
                                  margin:
                                      SharedData().currentWidth(context) > 600
                                          ? EdgeInsets.symmetric(
                                              horizontal: SharedData()
                                                      .currentWidth(context) *
                                                  0.3)
                                          : null,
                                  decoration: BoxDecoration(
                                    border:
                                        SharedData().currentWidth(context) > 600
                                            ? Border.all(
                                                width: 1, color: Colors.white)
                                            : null,
                                  ),
                                  child: PostPage(
                                    postSnap: model, snapshot: result,
                                    isCommentPage: false,
                                    // index: index,
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "no internet\n please check your internet and try again"),
                  ],
                ),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
