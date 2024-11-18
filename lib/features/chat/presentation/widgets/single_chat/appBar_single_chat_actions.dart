import 'package:flutter/material.dart';

import '../../../../calls/domain/entities/call_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../chat_utlis.dart';

class AppBarSingleChatActions extends StatelessWidget {
  final MessageEntity message;
  const AppBarSingleChatActions({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ChatUtils.makeCall(
          context,
          callEntity: CallEntity(
            callerId: message.senderUid,
            callerName: message.senderName,
            callerProfileUrl: message.senderProfile,
            receiverId: message.recipientUid,
            receiverName: message.recipientName,
            receiverProfileUrl: message.recipientProfile,
          ),
        );
      },
      child: const Icon(
        Icons.videocam_rounded,
        size: 25,
      ),
    );
  }
}
