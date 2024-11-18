import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:intl/intl.dart';

import '../../../../core/const/page_const.dart';
import '../../../../core/functions/navigationpage.dart';
import '../../../../core/shared/widgets/profile_widget.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../manager/chat/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  final String uid;

  const ChatPage({super.key, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context)
        .getMyChat(chat: ChatEntity(senderUid: widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var service = Provider.of<HandleImage>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          backgroundColor: Colors.black,
          onPressed: () {
            navigationNamePage(context, PageConst.friends, widget.uid);
          },
          child: const Text(
            "new Chat",
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoaded) {
                  final myChat = state.chatContacts;

                  if (myChat.isEmpty) {
                    return const Center(
                      child: Text("No Conversation Yet"),
                    );
                  }

                  return ListView.builder(
                      itemCount: myChat.length,
                      itemBuilder: (context, index) {
                        final chat = myChat[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.singleChatPage,
                              arguments: MessageEntity(
                                  senderUid: chat.senderUid,
                                  recipientUid: chat.recipientUid,
                                  senderName: chat.senderName,
                                  recipientName: chat.recipientName,
                                  senderProfile: chat.senderProfile,
                                  recipientProfile: chat.recipientProfile,
                                  uid: widget.uid),
                            );
                          },
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: profileWidget(
                                    imageUrl: chat.recipientProfile),
                              ),
                            ),
                            title: Text("${chat.recipientName}"),
                            subtitle: Text(
                              "${chat.recentTextMessage}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              DateFormat.jm().format(chat.createdAt!.toDate()),
                              style: const TextStyle(
                                  color: greyColor, fontSize: 13),
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: tabColor,
                  ),
                );
              },
            ),
          ),
        ));
  }
}
