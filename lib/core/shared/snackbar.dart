import 'package:flutter/material.dart';
import 'package:inistagram/core/theme/style.dart';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          height: 50,
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
        backgroundColor: blackColor,
      ),
    );
}
