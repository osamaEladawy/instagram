import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/features/notifications/cubit/notifications_cubit.dart';
import 'package:provider/provider.dart';

import '../../posts/screens/actions_post.dart';

class NotificationsUsers extends StatefulWidget {
  const NotificationsUsers({super.key});

  @override
  State<NotificationsUsers> createState() => _NotificationsUsersState();
}

class _NotificationsUsersState extends State<NotificationsUsers> {
  //final NotificationViewModel _model = NotificationViewModel();

  @override
  Widget build(BuildContext context) {
    var users = Provider.of<UsersProviders>(context).users;
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Notifications"),
          ),
          body: StreamBuilder(
            stream: NotificationsCubit.instance.showUsers("${users!.uid}"),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return HandelRequest(
                snapshot: snapshot,
                widget: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot result = snapshot.data!.docs[index];
                      Map<String, dynamic> response =
                          result.data()! as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            context.push(
                              PostSActions(
                                postId: '${response['postId']}',
                                message: '${response['message']}',
                                post: result,
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(response["imageUrl"]),
                          ),
                          title: Text("${response['username']}"),
                          subtitle: Text(
                            "${response['message']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: CircleAvatar(
                            backgroundImage: NetworkImage(response["postUrl"]),
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
        );
      },
    );
  }
}
