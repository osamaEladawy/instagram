import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/features/riles/presentation/pages/riles_page.dart';
import 'package:inistagram/core/providers/auth_service.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:provider/provider.dart';

import '../../views/post/add_post.dart';
import '../../views/screens/home.dart';
import '../../features/user/presentation/pages/profile_page.dart';
import '../../views/screens/search_page.dart';

class WebViewModel {
  int currentIndex = 0;
  Color currentColor = Colors.white60;
  Color colorWhenClick = Colors.white;
  late PageController controller;


  List<Widget> page(context) {
      List<Widget> pages = [];
    var user = Provider.of<UsersProviders>(context).users;
    pages = [
      const HomePage(),
      const SearchPage(),
      const AddPost(),
      if (user != null)
        RilesPage(
          currentUser: user,
        ),
      ProfilePage(
        uid: "${FirebaseAuth.instance.currentUser?.uid}",
      ),
    ];
    return pages;
  }
  
  // List<Widget> pages = [
  //   const HomePage(),
  //   const SearchPage(),
  //   const AddPost(),
  //   const RilesPage(),
  //    ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid,),
  // ];

  onChangePage(int page) {
    controller.jumpToPage(page);
    currentIndex = page;
  }

  changeState(value) {
    currentIndex = value;
  }

  Future<void> logOut(context) async {
    var service = Provider.of<AuthService>(context, listen: false);
    try {
      await service.logOut();
    } catch (e) {}
  }
}
