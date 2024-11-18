import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../features/user/data/remote/models/user_model.dart' as model;
import '../../features/user/data/remote/models/user_model.dart';


class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<model.UserModel> getUsersDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _store.collection("users").doc(currentUser.uid).get();

    return model.UserModel.fromSnapshot(snapshot);
  }

  login(String email, String password) async {
    String result = "some result";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "success";
        //return credential;
      } else {
        result = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      result = e.toString();
      throw Exception(e.message);
    }
    return result;
  }

  signUp(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required String urlImage}) async {
    String result = "initial process=============================";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          urlImage.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print("======================================================");
        print(credential.user!.uid);
        print("======================================================");

        //add information for user to database;

        UserModel userModel = UserModel(
            uid: credential.user!.uid,
            username: username,
            email: email,
            bio: bio,
            imageUrl: urlImage,
            following: [],
            followers: [],
            saves: [],
            isOnline: false,
            dateWhenLogOut: DateTime.now(),
            isPrivate: false,
            );

        await _store
            .collection("users")
            .doc(credential.user!.uid)
            .set(userModel.toSnapshot());
        result = "success========================================";
        return credential;
      }
    } on FirebaseAuthException catch (e) {
      result = e.toString();
      throw Exception(e.message);
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
