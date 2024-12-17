// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/const/colors.dart';

class ChecksAndConditions extends StatefulWidget {
  //conditions
  final bool isReplying;

  final FocusNode focusNode;

  final bool isShowAttachWindow;

  final bool isShowEmojiKeyboard;

  final bool isRecording;

  final TextEditingController textMessageController;
  void Function(String)? onChanged;
  final void Function()? toggleEmojiKeyboard;
  final void Function()? sendTextMessage;
  final void Function()? selectImage;
  final void Function()? showAttackAndEmoji;
  final void Function()? changeStateAttackWindow;

  final bool isDisplaySendButton;

  ChecksAndConditions(
      {super.key,
      required this.isReplying,
      required this.focusNode,
      required this.isShowAttachWindow,
      required this.isShowEmojiKeyboard,
      required this.textMessageController,
      required this.isDisplaySendButton,
      required this.toggleEmojiKeyboard,
      required this.sendTextMessage,
      required this.selectImage,
      required this.isRecording,
      required this.onChanged,
      required this.showAttackAndEmoji,
      required this.changeStateAttackWindow});

  @override
  State<ChecksAndConditions> createState() => _ChecksAndConditionsState();
}

class _ChecksAndConditionsState extends State<ChecksAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        top: widget.isReplying == true ? 0 : 5.h,
        bottom: 5.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: widget.isReplying == true
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(25.r),
                          bottomRight: Radius.circular(25.r))
                      : BorderRadius.circular(25.r)),
              height: 50.h,
              child: TextField(
                focusNode: widget.focusNode,
                onTap: widget.showAttackAndEmoji, //showAttackAndEmoje
                controller: widget.textMessageController,
                onChanged: widget.onChanged, //onChanged
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  prefixIcon: GestureDetector(
                    onTap: widget.toggleEmojiKeyboard, //toggleEmojiKeyboard
                    child: Icon(
                        widget.isShowEmojiKeyboard == false
                            ? Icons.emoji_emotions
                            : Icons.keyboard_outlined,
                        color: greyColor),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(top: 12.0.h),
                    child: Wrap(
                      children: [
                        Transform.rotate(
                          angle: -0.5,
                          child: GestureDetector(
                            onTap: widget.changeStateAttackWindow,
                            child: const Icon(
                              Icons.attach_file,
                              color: greyColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        GestureDetector(
                          onTap: widget.selectImage,
                          child: const Icon(
                            Icons.camera_alt,
                            color: greyColor,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        GestureDetector(
                          onTap: widget.sendTextMessage,
                          child: Container(
                            //padding: EdgeInsets.only(bottom: 2),
                            //alignment: Alignment.center,
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Icon(
                                widget.isDisplaySendButton ||
                                        widget.textMessageController.text
                                            .isNotEmpty
                                    ? Icons.send_outlined
                                    : widget.isRecording
                                        ? Icons.close
                                        : Icons.mic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0.w),
                      ],
                    ),
                  ),
                  hintText: 'Message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
