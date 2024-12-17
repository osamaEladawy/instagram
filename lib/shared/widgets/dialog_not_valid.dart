import 'package:flutter/material.dart';

class DialogWhenNotValid extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool verifyCode;
  const DialogWhenNotValid(
      {super.key,
      this.onPressed,
      required this.text,
      required this.verifyCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        verifyCode
            ? "you must enter verification  code"
            : "you must enter your name and pic",
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
