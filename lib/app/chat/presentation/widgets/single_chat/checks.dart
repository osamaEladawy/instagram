// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../../../core/theme/style.dart';

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
      required this.onChanged,required this.showAttackAndEmoji,
      required this.changeStateAttackWindow});

  @override
  State<ChecksAndConditions> createState() => _ChecksAndConditionsState();
}

class _ChecksAndConditionsState extends State<ChecksAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: widget.isReplying == true ? 0 : 5,
          bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: widget.isReplying == true
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))
                      : BorderRadius.circular(25)),
              height: 50,
              child: TextField(
                focusNode: widget.focusNode,
                onTap: widget.showAttackAndEmoji,//showAttackAndEmoje
                controller: widget.textMessageController,
                onChanged: widget.onChanged,//onChanged
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: GestureDetector(
                    onTap: widget.toggleEmojiKeyboard,//toggleEmojiKeyboard
                    child: Icon(
                        widget.isShowEmojiKeyboard == false
                            ? Icons.emoji_emotions
                            : Icons.keyboard_outlined,
                        color: greyColor),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
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
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap:widget.selectImage,
                          child: const Icon(
                            Icons.camera_alt,
                            color: greyColor,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: widget.sendTextMessage,
                          child: Container(
                            //padding: EdgeInsets.only(bottom: 2),
                            //alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),),
                            child: Center(
                              child: Icon(
                                widget.isDisplaySendButton ||
                                    widget.textMessageController.text.isNotEmpty
                                    ? Icons.send_outlined
                                    : widget.isRecording
                                    ? Icons.close
                                    : Icons.mic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
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
