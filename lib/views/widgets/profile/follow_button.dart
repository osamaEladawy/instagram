import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color? textColor;

  const FollowButton(
      {super.key,
      this.onPressed,
      required this.backgroundColor,
      required this.borderColor,
      required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: 270,
      height: 60,
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(text,style: TextStyle(
            fontSize: 15,fontWeight: FontWeight.bold,
            color: textColor,
          ),),
        ),
      ),
    );
  }
}
