import 'package:flutter/material.dart';
import 'package:inistagram/features/user/presentation/pages/login.dart';
import 'package:inistagram/features/user/presentation/pages/signup.dart';

class LoginAndSignUp extends StatefulWidget {
  const LoginAndSignUp({super.key});

  @override
  State<LoginAndSignUp> createState() => _LoginAndSignUpState();
}

class _LoginAndSignUpState extends State<LoginAndSignUp> {
  bool isLogin = true;
  changeState(){
    setState(() {
      isLogin = !isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return LoginPage(onTap: changeState,);
    }else{
      return SignUp(onTap: changeState);
    }
  }
}
