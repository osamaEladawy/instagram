import 'package:flutter/material.dart';

class DialogForPassword extends StatelessWidget {
  final String content;
  final void Function()? onPressed;
  final void Function()? onCancle;
  const DialogForPassword({super.key, required this.content, required this.onPressed, this.onCancle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Haye!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      content:  Text(content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onCancle,
              child:  const Text(
                "Cancle",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ),
            const SizedBox(width: 20,),
             ElevatedButton(
              onPressed: onPressed,
              child: const Text(
                "Ok",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
