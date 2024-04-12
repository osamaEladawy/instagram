

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_service.dart';
import '../../core/class/handle_image.dart';
import '../../core/const/page_const.dart';
import '../../core/globel/functions/navigationpage.dart';

class SignUpViewModel{
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  TextEditingController get name => _name;
  TextEditingController get email => _email;
  TextEditingController get password => _password;
  TextEditingController get confirmPassword => _confirmPassword;
  TextEditingController get bio => _bio;
  final myKey = GlobalKey<FormState>();
  final HandleImage handleImage = HandleImage();
  bool? isValid;
  bool isHide = false;

  changeState() {
    if (_password.text.isNotEmpty || _confirmPassword.text.isNotEmpty) {
      isHide = isHide == false ? true : false;
      return;
    }
  }




  signUp(context) async {
    if (myKey.currentState!.validate()) {
      isValid = true;
      if (_password.text != _confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("passwords not matches!"),
          ),
        );
        return; 
      } else {
        var service = Provider.of<AuthService>(context, listen: false);
        var handler = Provider.of<HandleImage>(context, listen: false);
        if (handler.url != null && handler.file != null) {
          try {
            UserCredential userCredential = await service.signUp(
                email: _email.text,
                password: _password.text,
                username: _name.text,
                bio: _bio.text,
                urlImage: '${handler.url}');
            await userCredential.user!.sendEmailVerification();
            navigationNameReplacePage(context,PageConst.loginPage);
            handler.clearImage();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("please upload image"),
            ),
          );
        }
      }
    } else {
      isValid = false;
      print("not valid");
    }
  }

}