import 'package:flutter/material.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/postsforuser.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/savesforuser.dart';

class TabsForPosts extends StatefulWidget {
  final String uid;
  final String postId;
 

  const TabsForPosts({super.key, required this.uid, required this.postId,});

  @override
  State<TabsForPosts> createState() => _TabsForPostsState(); 
}

class _TabsForPostsState extends State<TabsForPosts>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: controller, tabs: const [
          Tab(
            icon: Icon(
              Icons.photo_sharp,
            ),
          ),
          Tab(
            icon: Icon(Icons.bookmark_outline),
          ),
          Tab(
            icon: Icon(
              Icons.person,
            ),
          ),
        ]),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 370,
          //height: MediaQuery.of(context).size.height / 1.8,
          child: TabBarView(
            controller: controller, children: [
            PostsForUser(uid: widget.uid),
            SavesForUser(uid: widget.uid, postId: widget.postId,),
            GridView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: Image.asset("assets/images/profile_default.png"),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
            ),
          ]),
        )
      ],
    );
  }
}
