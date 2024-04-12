import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/app/riles/presentation/pages/riles_page.dart';
import 'package:inistagram/controller/user_providers.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_service.dart';
import '../../views/post/add_post.dart';
import '../../views/screens/home.dart';
import '../../app/user/presentation/pages/profile_page.dart';
import '../../views/screens/search_page.dart';

class MobileViewModel {
  int currentIndex = 0;
  Color currentColor = Colors.white60;
  Color colorWhenClick = Colors.white;
  late PageController controller;
 
 List<Widget> pages = [];

  List<Widget> page(context) {
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

  onChangePage(int page) {
    controller.jumpToPage(page);
  }

  changeState(int value) {
    currentIndex = value;
  }


}
