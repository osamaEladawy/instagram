import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handel_request.dart';

class PostsForUser extends StatelessWidget {
  final String uid;
  const PostsForUser({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("posts")
            .where("uid", isEqualTo: uid)
            .get(),
        builder: (context, snapshot) {
         return HandelRequest(snapshot: snapshot, widget: GridView.builder(
            padding: const EdgeInsets.only(top: 10),
             shrinkWrap: true,
              itemCount:snapshot.data?.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                QueryDocumentSnapshot postSnap = snapshot.data!.docs[index];
                return Card(
                  child: Image.network(postSnap['postUrl']),
                );
              }),);
        });
  }
}