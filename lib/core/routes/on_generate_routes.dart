import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/features/status/domain/entities/status_entity.dart';
import 'package:inistagram/features/status/presentation/pages/my_status_page.dart';
import 'package:inistagram/features/status/presentation/pages/status_page.dart';
import 'package:inistagram/features/user/domain/entities/user_entity.dart';
import 'package:inistagram/features/chat/presentation/pages/friends.dart';
import 'package:inistagram/features/user/presentation/pages/edit_profile_page.dart';
import 'package:inistagram/features/user/presentation/pages/initialpage.dart';
import 'package:inistagram/features/responsive/screens/responsive_page.dart';
import 'package:inistagram/features/home/screens/home.dart';
import 'package:inistagram/features/user/presentation/pages/profile_page.dart';

import '../../features/chat/domain/entities/message_entity.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/single_chat_page.dart';
import 'page_const.dart';
import '../../features/user/presentation/pages/login.dart';
import '../../features/user/presentation/pages/signup.dart';
import '../../features/notifications/screens/notifications_users.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.profilePage:
        if (args is String) {
          return _buildRoute(ProfilePage(uid: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.friends:
        if (args is String) {
          return _buildRoute(Friends(uid: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.editProfilePage:
        if (args is UserEntity) {
          return _buildRoute(EditProfilePage(currentUser: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.notifications:
        return _buildRoute(NotificationsUsers(), isIos);
      case PageConst.initialPage:
        return _buildRoute(InitialPage(), isIos);
      case PageConst.chatPage:
        if (args is String) {
          return _buildRoute(ChatPage(uid: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      case PageConst.myStatusPage:
        if (args is StatusEntity) {
          return _buildRoute(MyStatusPage(status: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      case PageConst.loginPage:
        if (args is void Function()?) {
          return _buildRoute(LoginPage(onTap: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.signPage:
        if (args is void Function()?) {
          return _buildRoute(SignUp(onTap: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.homePage:
        //if (args is void Function()?) {
        return _buildRoute(HomePage(), isIos);
      // } else {
      //   return _buildRoute(const UndefinedWidget(), isIos);
      // }

      case PageConst.singleChatPage:
        if (args is MessageEntity) {
          return _buildRoute(SingleChatPage(message: args), isIos);
        } else {
          return _buildRoute(UndefinedWidget(), isIos);
        }

      case PageConst.statusPage:
        if (args is UserEntity) {
          return _buildRoute(StatusPage(currentUser: args), isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }
      case PageConst.responsive:
        if (args is Widget) {
          return _buildRoute(
              ResponsivePage(
                webScreen: args,
                mobileScreen: args,
              ),
              isIos);
        } else {
          return _buildRoute(const UndefinedWidget(), isIos);
        }

      default:
        return _buildRoute(const UndefinedWidget(), isIos);
    }
  }

  static _buildRoute(Widget page, bool isIos) {
    if (isIos) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }
}

class UndefinedWidget extends StatelessWidget {
  const UndefinedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("undefined"),
      ),
      body: const Center(
        child: Text("undefined"),
      ),
    );
  }
}
