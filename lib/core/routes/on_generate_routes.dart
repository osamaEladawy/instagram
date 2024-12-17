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
import '../const/page_const.dart';
import '../../features/user/presentation/pages/login.dart';
import '../../features/user/presentation/pages/signup.dart';
import '../../features/notifications/screens/notifications_users.dart';

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
      // case PageConst.singleChatPage:
      //   {
      //     if (args is MessageEntity) {
      //       return materialPageBuilder(SingleChatPage(
      //         message: args,
      //       ));
      //     } else {
      //       return materialPageBuilder(const ErrorPage());
      //     }
      //   }
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

      // case PageConst.responsive:
      //   {
      //     return materialPageBuilder(InitialPage());
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
