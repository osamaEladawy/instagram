import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/main.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_service.dart';
import '../../core/const/page_const.dart';
import '../../core/globel/functions/navigationpage.dart';
import '../../views/widgets/auth/custom_dialog.dart';

class LoginViewModel {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var data = {};

  TextEditingController get email => _email;
  TextEditingController get password => _password;

  final myKey = GlobalKey<FormState>();
  bool? isValid;
  bool isHide = false;

  changeState() {
    if (_password.text.isNotEmpty) {
      isHide = isHide == false ? true : false;
      return;
    }
  }

  login(context) async {
    if (myKey.currentState!.validate()) {
      isValid = true;
      var service = Provider.of<AuthService>(context, listen: false);
      try {
        await service.login(_email.text.trim(), _password.text.trim());
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .get()
            .then((value) async {
          if (value.data() != null) {
            data = value.data()!;
            preferences.setString('uid', data['uid'].toString());
            String? userId = preferences.getString("uid");
            FirebaseMessaging.instance.subscribeToTopic("users");
            FirebaseMessaging.instance.subscribeToTopic("users$userId");
            print("============================================login");
            print("$userId   login");
            print("============================================login");
            var updateUser =
                FirebaseFirestore.instance.collection("users").doc(data["uid"]);
            await updateUser.update({"isOnline": true});
            navigationNamePageAndRemoveAll(context, PageConst.initialPage);
          }
        });
      } catch (e) {
        print("==================");
        print(e.toString());
        print("==================");
        if (e.toString() ==
                "Exception: The supplied auth credential is incorrect, malformed or has expired." ||
            e.toString() ==
                "Exception: We have blocked all requests from this device due to unusual activity. Try again later.") {
          return showDialog(
              context: context, builder: (context) => _alertDialog(context));
        } else {}
      }
    } else {
      print("not valid");
      isValid = false;
    }
  }

  _alertDialog(context) {
    return AlertDialog(
      title: const Text("haye"),
      content: const Text("resend new link"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(context);
                },
                child: const Text("No")),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser!
                      .sendEmailVerification()
                      .then((value) {
                    Navigator.of(context).maybePop(context);
                  });
                },
                child: const Text("send"))
          ],
        )
      ],
    );
  }

  forgetPassword(context) async {
    if (_email.text.isEmpty || _email.text == "") {
      showDialog(
        context: context,
        builder: (context) => DialogForPassword(
          content: "please Enter your email",
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
      showDialog(
        context: context,
        builder: (context) => DialogForPassword(
          content: "please check your gmail now",
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => DialogForPassword(
          content: "This is not Gmail",
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      );
    }
  }
}
