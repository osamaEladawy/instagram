import 'package:flutter/material.dart';

class ListofAttachWindowItems extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String title;
  const ListofAttachWindowItems({super.key, required this.color, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(40)),
              child: Icon(icon,size: 30,),
        ),
        Text(title)
      ],
    );
  }
}
