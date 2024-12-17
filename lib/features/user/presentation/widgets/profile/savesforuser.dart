import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/shared/model/save_posts.dart';
import 'package:inistagram/features/save_posts/screens/savepost_page.dart';

class SavesForUser extends StatelessWidget {
  final String uid;
  final String postId;
  const SavesForUser({super.key, required this.uid, required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("savePosts")
            .where("currentUserId", isEqualTo: uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return HandelRequest(
            snapshot: snapshot,
            widget: GridView.builder(
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot snap = snapshot.data!.docs[index];

                  SavePostModel savePost = SavePostModel.fromSnapshot(snap);

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SavePostPage(
                            postId: savePost.postId!,
                            uid: uid,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network("${savePost.postUrl}", height: 80.h),
                            Text("${savePost.descriptionForPost}"),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
