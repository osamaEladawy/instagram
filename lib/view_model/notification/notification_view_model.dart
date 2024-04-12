import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationViewModel {
  Stream<QuerySnapshot<Map<String, dynamic>>> showUsers(String uid) =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("notifications")
          .snapshots();
}
