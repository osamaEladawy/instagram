import 'package:flutter/material.dart';

import '../../../../../core/theme/style.dart';


class StackOfProfileImage extends StatelessWidget {
  final void Function()? onPressed;
  final ImageProvider<Object>? backgroundImage;
  const StackOfProfileImage({super.key, this.onPressed, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 57,
          backgroundImage: backgroundImage,
        ),
        Positioned(
          bottom: 1,
          right: 2,
          child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tabColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
