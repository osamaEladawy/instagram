import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/views/auth/login_signup.dart';
import 'package:inistagram/views/responsive/mobile_screen.dart';
import 'package:inistagram/views/responsive/responsive_page.dart';
import 'package:inistagram/views/responsive/web_screen.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              FirebaseAuth.instance.currentUser!.emailVerified) {
            return const ResponsivePage(
                webScreen: WebScreen(), mobileScreen: MobileScreen());
          } else {
            return const LoginAndSignUp();
          }
        });
  }
}
