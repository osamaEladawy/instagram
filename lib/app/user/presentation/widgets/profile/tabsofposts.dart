import 'package:flutter/material.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/postsforuser.dart';
import 'package:inistagram/app/user/presentation/widgets/profile/savesforuser.dart';

class TabsForPosts extends StatefulWidget {
  final String uid;
  final String postId;

  const TabsForPosts({
    super.key,
    required this.uid,
    required this.postId,
  });

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
              Icons.grid_on_sharp,
            ),
            text: "posts",
          ),
          Tab(icon: Icon(Icons.bookmark_outline), text: "saves"),
          Tab(icon: Icon(Icons.person), text: "tags"),
        ]),
        Container(
          color: Colors.red,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.50,
          child: TabBarView(controller: controller, children: [
            PostsForUser(uid: widget.uid),
            SavesForUser(
              uid: widget.uid,
              postId: widget.postId,
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Image.asset("assets/images/profile_default.png"),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
