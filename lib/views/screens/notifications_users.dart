import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/controller/user_providers.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/view_model/notification/notification_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/globel/functions/navigationpage.dart';
import '../post/actions_post.dart';

class NotificationsUsers extends StatefulWidget {
  const NotificationsUsers({super.key});

  @override
  State<NotificationsUsers> createState() => _NotificationsUsersState();
}

class _NotificationsUsersState extends State<NotificationsUsers> {
  final NotificationViewModel _model = NotificationViewModel();

  @override
  Widget build(BuildContext context) {
    var users = Provider.of<UsersProviders>(context).users;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder(
        stream: _model.showUsers("${users!.uid}"),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return HandelRequest(snapshot: snapshot, widget: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot result = snapshot.data!.docs[index];
                Map<String, dynamic> response =
                result.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    onTap: () {
                      navigationPage(
                        context,
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
              }),);
        },
      ),
    );
  }
}
