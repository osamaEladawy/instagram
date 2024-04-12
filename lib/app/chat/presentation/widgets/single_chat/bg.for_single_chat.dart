import 'package:flutter/material.dart';

class BackGroundSingleChat extends StatelessWidget {
  const BackGroundSingleChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: Image.asset("assets/images/whatsapp_bg_image.png", fit: BoxFit.cover),
    );
  }
}
