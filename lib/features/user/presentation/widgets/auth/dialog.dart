import 'dart:io';

import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Haye!",textAlign: TextAlign.center,),
      content: const Text("Are you exit application"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: const Text("No"),
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      ],
    );
  }
}
