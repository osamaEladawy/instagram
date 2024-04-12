import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchViewModel {
  final TextEditingController search = TextEditingController();
  bool isShowUsers = false;

  Future<QuerySnapshot<Map<String, dynamic>>> searchForUsers() async =>
     await FirebaseFirestore.instance
          .collection("users")
          .where("username", isGreaterThanOrEqualTo: search.text)
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> searchForPosts() async =>
     await FirebaseFirestore.instance.collection("posts").get();


}

