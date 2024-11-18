import 'package:flutter/material.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/my_app.dart';

showSnackBar(String content) {
  ScaffoldMessenger.of(navigatorKey.currentContext!)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            content,textAlign: TextAlign.center,
            style: const TextStyle(color: whiteColor),
          ),
        ),
        backgroundColor: Colors.grey[600],
      ),
    );
}
