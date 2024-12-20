import 'package:flutter/material.dart';
import 'package:inistagram/core/const/colors.dart';

class ImageForUsers extends StatelessWidget {
  final void Function()? onTap;
  final ImageProvider<Object>? child;
  const ImageForUsers({super.key,required this.onTap,required this.child});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: CircleAvatar(
           radius: 40,
            backgroundImage:child,
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: whiteColor,
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: blackColor,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }
}