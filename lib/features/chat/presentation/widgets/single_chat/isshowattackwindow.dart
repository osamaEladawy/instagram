import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/const/colors.dart';

class IsShowAttackWindow extends StatelessWidget {
  final void Function()? onTap;
  final void Function(Category?, Emoji) onEmojiSelected;
  const IsShowAttackWindow(
      {super.key, this.onTap, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310.h,
      child: Stack(
        children: [
          EmojiPicker(
              config: const Config(bgColor: backgroundColor),
              onEmojiSelected: onEmojiSelected),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 40.h,
              decoration: const BoxDecoration(color: appBarColor),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: greyColor,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20,
                          color: tabColor,
                        ),
                        SizedBox(width: 15.w),
                        Icon(
                          Icons.gif_box_outlined,
                          size: 20,
                          color: greyColor,
                        ),
                        SizedBox(width: 15.w),
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
