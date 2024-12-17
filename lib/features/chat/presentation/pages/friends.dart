import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/const/colors.dart';

import '../../../../core/routes/page_const.dart';
import '../../../../shared/widgets/profile_widget.dart';
import '../../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import '../../../user/presentation/manager/user/user_cubit.dart';
import '../../domain/entities/message_entity.dart';

class Friends extends StatefulWidget {
  final String uid;
  const Friends({super.key, required this.uid});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool loading = false;

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            final currentUser = state.userEntity;

            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final contacts = state.users
                      .where((user) => user.uid != widget.uid)
                      .toList();

                  if (contacts.isEmpty) {
                    return const Center(
                      child: Text("No Contacts Yet"),
                    );
                  }

                  return SafeArea(
                    child: ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PageConst.singleChatPage,
                                arguments: MessageEntity(
                                  senderUid: currentUser.uid,
                                  recipientUid: contact.uid,
                                  senderName: currentUser.username,
                                  recipientName: contact.username,
                                  senderProfile: currentUser.imageUrl,
                                  recipientProfile: contact.imageUrl,
                                  uid: widget.uid,
                                ),
                              );
                            },
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child:
                                profileWidget(imageUrl: contact.imageUrl),
                              ),
                            ),
                            title: Text("${contact.username}"),
                            subtitle: Text("${contact.bio}"),
                          );
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: tabColor,
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: tabColor,
            ),
          );
        },
      ),
    );
  }
}
