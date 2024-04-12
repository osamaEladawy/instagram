import 'package:flutter/material.dart';

class HaveAccountOrNot extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const HaveAccountOrNot({super.key, this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return     Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(
          width: 15,
        ),
        InkWell(
          onTap: onTap,
          child: const Text( "Click here",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.red),
          ),
        ),
      ],
    );
  }
}
