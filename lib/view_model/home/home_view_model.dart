import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/shared/snackbar.dart';

class HomeViewModel {
  late Timestamp time;
  int commentIndex = 0;

  bool show = true;
  bool isAnimation = false;

  var postLength = {};
  var userData = {};

  var likes = [];
  int likesLength = 0;
  bool isFollow = false;
  bool loading = false;

  var users = [];

  var savePostData = {};
  var postData = {};

  getPosts() async {
    loading = true;

    await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        postData = element.data();

        print(
            "save posts =============================================PostData");
        print(postData);
        print(
            "save posts =============================================PostData");
      });
      loading = false;
    });
    loading = false;
  }

  getSavePosts() async {
    loading = true;
    await FirebaseFirestore.instance
        .collection("savePosts")
        .where("currentUserId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("postId", isEqualTo: postData['postId'])
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        savePostData = element.data();

        print(
            "save posts =============================================savePostData");
        print(savePostData);
        print(
            "save posts =============================================savePostData");
      });
      loading = false;
    });
    loading = false;
  }

  getUsers(context, uid) async {
    loading = true;
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      userData = userSnap.data()!;
      print("====================================users");
      print(users);
      print("====================================users");
    } catch (e) {
      showSnackBar("no data for users", context);
    }
    loading = false;
  }

  // notificationOnMessage(context) {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //       print('====================ForGround================');
  //       showSnackBar("${message.notification!.body}", context);
  //     }
  //   });
  // }

  // notificationWhenOpenApp() {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print(
  //         "========================================================> Text Message");
  //     if (message.data['type'] == 'none') {
  //       //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ChatPage(body:"$body"), ));
  //       print(
  //           "========================================================> Text Message Done");
  //     }
  //   });
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() =>
      FirebaseFirestore.instance.collection("posts").snapshots();

  getData(context, mounted, uid) async {
    if (mounted) {
      loading = true;
    }
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      if (mounted) {
        userData = userSnap.data()!;
        isFollow = userSnap.data()!['followers'].contains(currentUser);
      }
    } catch (e) {
      print(e.toString());
    }
    if (mounted) {
      loading = false;
    }
  }

  getCommentIndex(context, mounted, uid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(uid)
          .collection('comments')
          .get();
      if (mounted) {
        commentIndex = snapshot.docs.length;
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
