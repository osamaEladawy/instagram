import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../core/const/message_type_const.dart';
import '../../../../../shared/widgets/display_alret.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/entities/message_replay_entity.dart';
import '../../manager/message/message_cubit.dart';
import '../message/message_replay_type_widget.dart';
import '../message/message_type_widget.dart';

class ListOfMessages extends StatefulWidget {
  final String? recipientProfile;
  final ScrollController? scrollController;
  final List<MessageEntity> messages;
  final FocusNode focusNode;
  final MessageEntity messageEntity;
  final MessageCubit provider;
  const ListOfMessages(
      {super.key,
      required this.scrollController,
      required this.messages,
      required this.focusNode,
      required this.messageEntity,
      required this.provider,
      required this.recipientProfile});

  @override
  State<ListOfMessages> createState() => _ListOfMessagesState();
}

class _ListOfMessagesState extends State<ListOfMessages> {
  void onMessageSwipe({
    String? message,
    String? username,
    String? type,
    bool? isMe,
  }) {
    BlocProvider.of<MessageCubit>(context).setMessageReplay =
        MessageReplayEntity(
            message: message,
            username: username,
            messageType: type,
            isMe: isMe);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          final message = widget.messages[index];

          if (message.isSeen == false &&
              message.recipientUid == widget.messageEntity.uid) {
            widget.provider.seenMessage(
                message: MessageEntity(
                    senderUid: widget.messageEntity.senderUid,
                    recipientUid: widget.messageEntity.recipientUid,
                    messageId: message.messageId));
          }

          if (message.senderUid == widget.messageEntity.senderUid) {
            return _messageLayout(
              messageType: message.messageType,
              message: message.message,
              alignment: Alignment.centerRight,
              mainAxisAlignment: MainAxisAlignment.end,
              createAt: message.createdAt,
              isSeen: message.isSeen,
              isShowTick: true,
              messageBgColor: Colors.purpleAccent, // messageColor,
              rightPadding: message.repliedMessage == "" ? 85 : 5,
              reply: MessageReplayEntity(
                  message: message.repliedMessage,
                  messageType: message.repliedMessageType,
                  username: message.repliedTo),
              onLongPress: () {
                widget.focusNode.unfocus();
                displayAlertDialog(context, onTap: () {
                  BlocProvider.of<MessageCubit>(context).deleteMessage(
                      message: MessageEntity(
                          senderUid: widget.messageEntity.senderUid,
                          recipientUid: widget.messageEntity.recipientUid,
                          messageId: message.messageId));
                  Navigator.pop(context);
                },
                    confirmTitle: "Delete",
                    content: "Are you sure you want to delete this message?");
              },
              onSwipe: (tr) {
                onMessageSwipe(
                    message: message.message,
                    username: message.senderName,
                    type: message.messageType,
                    isMe: true);

                setState(() {});
              },
            );
          } else {
            return _messageLayout(
              messageType: message.messageType,
              message: message.message,
              alignment: Alignment.centerLeft,
              mainAxisAlignment: MainAxisAlignment.start,
              createAt: message.createdAt,
              isSeen: message.isSeen,
              isShowTick: false,
              messageBgColor: senderMessageColor,
              rightPadding: message.repliedMessage == "" ? 85 : 5,
              reply: MessageReplayEntity(
                message: message.repliedMessage,
                messageType: message.repliedMessageType,
                username: message.repliedTo,
              ),
              senderId: message.senderUid,
              recipientId: message.recipientUid,
              onLongPress: () {
                widget.focusNode.unfocus();
                displayAlertDialog(context, onTap: () {
                  BlocProvider.of<MessageCubit>(context).deleteMessage(
                      message: MessageEntity(
                          senderUid: widget.messageEntity.senderUid,
                          recipientUid: widget.messageEntity.recipientUid,
                          messageId: message.messageId));
                  Navigator.pop(context);
                },
                    confirmTitle: "Delete",
                    content: "Are you sure you want to delete this message?");
              },
              onSwipe: (tr) {
                onMessageSwipe(
                    message: message.message,
                    username: message.senderName,
                    type: message.messageType,
                    isMe: false);

                setState(() {});
              },
            );
          }
        },
      ),
    );
  }

  _messageLayout({
    Color? messageBgColor,
    required AlignmentGeometry alignment,
    Timestamp? createAt,
    void Function(DragUpdateDetails)? onSwipe,
    String? message,
    String? messageType,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
    MessageReplayEntity? reply,
    double? rightPadding,
    String? senderId,
    String? recipientId,
    required MainAxisAlignment mainAxisAlignment,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: SwipeTo(
        onRightSwipe: onSwipe,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Align(
            alignment: alignment,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              children: [
                if (senderId != recipientId)
                  CircleAvatar(
                    backgroundImage: NetworkImage("${widget.recipientProfile}"),
                  ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      padding: EdgeInsets.only(
                          left: 5,
                          right: messageType == MessageTypeConst.textMessage
                              ? rightPadding!
                              : 5.w,
                          top: 5.h,
                          bottom: 5),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.80),
                      decoration: BoxDecoration(
                          color: messageBgColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reply?.message == null || reply?.message == ""
                              ? const SizedBox()
                              : Container(
                                  height: reply!.messageType ==
                                          MessageTypeConst.textMessage
                                      ? 70.h
                                      : 80.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: double.infinity,
                                        width: 4.5.w,
                                        decoration: BoxDecoration(
                                          color: reply.username ==
                                                  widget.messageEntity
                                                      .recipientName
                                              ? Colors.deepPurpleAccent
                                              : tabColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0.w, vertical: 5.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${reply.username == widget.messageEntity.recipientName ? reply.username : "You"}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: reply.username ==
                                                            widget.messageEntity
                                                                .recipientName
                                                        ? Colors
                                                            .deepPurpleAccent
                                                        : tabColor),
                                              ),
                                              MessageReplayTypeWidget(
                                                message: reply.message,
                                                type: reply.messageType,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 3.h),
                          MessageTypeWidget(
                            message: message,
                            type: messageType,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(DateFormat.jm().format(createAt!.toDate()),
                                  style: const TextStyle(
                                      fontSize: 12, color: whiteColor)),
                              SizedBox(width: 10.w),
                              isShowTick == true
                                  ? Icon(
                                      isSeen == true
                                          ? Icons.done_all
                                          : Icons.done,
                                      size: 16,
                                      color: isSeen == true
                                          ? Colors.white
                                          : whiteColor,
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isShowTick == true
                          ? Text(
                              isSeen == true ? "seen" : "",
                              style: const TextStyle(color: greyColor),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
