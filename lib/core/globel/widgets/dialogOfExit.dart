
import 'package:flutter/material.dart'; 

class DialogOfExit extends StatelessWidget {
  final void Function()? exit;
  final String? title;
  final String? content;
  const DialogOfExit({super.key, this.exit, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you want to exit"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).maybePop();
            }, child: const Text('No')),
            const SizedBox(width: 30,),
            ElevatedButton(
              onPressed:exit,
            child: const Text('Yes')),
          ],
        )
      ],
    );
  }
}