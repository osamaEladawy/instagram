import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/style.dart';

class IsShowAttackWindow extends StatelessWidget {
  final void Function()? onTap;
  final void Function(Category?, Emoji) onEmojiSelected;
  const IsShowAttackWindow({super.key, this.onTap, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: Stack(
        children: [
          EmojiPicker(
            config:
             const Config(bgColor: backgroundColor),
            onEmojiSelected: onEmojiSelected
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(color: appBarColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: greyColor,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20,
                          color: tabColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.gif_box_outlined,
                          size: 20,
                          color: greyColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.ad_units,
                          size: 20,
                          color: greyColor,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: const Icon(
                        Icons.backspace_outlined,
                        size: 20,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
