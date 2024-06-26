import 'package:flutter/material.dart';
import 'package:inistagram/app/status/domain/entities/status_entity.dart';
import 'package:inistagram/app/status/presentation/pages/my_status_page.dart';
import 'package:inistagram/app/status/presentation/pages/status_page.dart';
import 'package:inistagram/app/user/domain/entities/user_entity.dart';
import 'package:inistagram/app/chat/presentation/pages/friends.dart';
import 'package:inistagram/app/user/presentation/pages/edit_profile_page.dart';
import 'package:inistagram/views/auth/initialpage.dart';
import 'package:inistagram/views/screens/home.dart';
import 'package:inistagram/app/user/presentation/pages/profile_page.dart';

import '../app/chat/domain/entities/message_entity.dart';
import '../app/chat/presentation/pages/chat_page.dart';
import '../app/chat/presentation/pages/single_chat_page.dart';
import '../core/const/page_const.dart';
import '../views/auth/login.dart';
import '../views/auth/signup.dart';
import '../views/screens/notifications_users.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.profilePage:
        {
          if (args is String) {
            return materialPageBuilder(ProfilePage(uid: args));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.friends:
        {
          if (args is String) {
            return materialPageBuilder(Friends(
              uid: args,
            ));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return materialPageBuilder(EditProfilePage(
              currentUser: args,
            ));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }

      case PageConst.notifications:
        {
          //if(args is String) {
          return materialPageBuilder(const NotificationsUsers());
          //} else {
          //return materialPageBuilder( const ErrorPage());
          //}
        }
      case PageConst.chatPage:
        {
          if (args is String) {
            return materialPageBuilder(ChatPage(
              uid: args,
            ));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.singleChatPage:
        {
          if (args is MessageEntity) {
            return materialPageBuilder(SingleChatPage(
              message: args,
            ));
          } else {
            return materialPageBuilder(const ErrorPage());
          }
        }
      case PageConst.loginPage:
        {
          if (args is void Function()?) {
            return materialPageBuilder(LoginPage(
              onTap: args,
            ));
          }
          return materialPageBuilder(const ErrorPage());
        }

      case PageConst.signPage:
        {
          if (args is void Function()?) {
            return materialPageBuilder(SignUp(
              onTap: args,
            ));
          }
          return materialPageBuilder(const ErrorPage());
        }

      case PageConst.homePage:
        {
          return materialPageBuilder(const HomePage());
        }
      case PageConst.initialPage:
        {
          return materialPageBuilder(const InitialPage());
        }

      // case PageConst.postPage:
      //   {
      //     if (args is QueryDocumentSnapshot) {
      //       return materialPageBuilder(PostPage(
      //         postSnap: args,
      //       ));
      //     }
      //     return materialPageBuilder(const ErrorPage(
      //       isIWantShowError: false,
      //     ));
      //   }

        

      case PageConst.myStatusPage:
        {
          if (args is StatusEntity) {
            return materialPageBuilder(MyStatusPage(
              status: args,
            ));
          }
          return materialPageBuilder(const ErrorPage(
            isIWantShowError: false,
          ));
        }

      case PageConst.statusPage:
        {
          if (args is UserEntity) {
            return materialPageBuilder(StatusPage(
              currentUser: args,
            ));
          }
          return materialPageBuilder(const ErrorPage());
        }
    }
    return null;
  }
}

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  final bool? isIWantShowError;
  const ErrorPage({super.key, this.isIWantShowError = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: Center(
        child: isIWantShowError == true
            ? const Text("Error")
            : const Text("Not have any stories"),
      ),
    );
  }
}
