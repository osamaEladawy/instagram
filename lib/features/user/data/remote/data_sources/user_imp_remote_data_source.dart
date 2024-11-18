import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/core/storage/pref_services.dart';
import 'package:inistagram/features/user/data/remote/data_sources/user_remote_data_sources.dart';
import 'package:inistagram/features/user/data/remote/models/user_model.dart';

import '../../../../../core/const/firebase_collection_const.dart';
import '../../../domain/entities/user_entity.dart';

class UserImpRemoteDataSource implements UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  UserImpRemoteDataSource({required this.auth, required this.store});

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Future createUserEntity(UserEntity userEntity) async {
    final userCollection = store.collection(FirebaseCollectionConst.users);

    //final String uid = await getCurrentUid();

    print("new user entity Uid == ${userEntity.uid}");
    final newUser = UserModel(
      uid: userEntity.uid,
      username: userEntity.username,
      email: userEntity.email,
      bio: userEntity.bio,
      imageUrl: userEntity.imageUrl,
      following: userEntity.following,
      followers: userEntity.followers,
      saves: userEntity.saves,
      isOnline: userEntity.isOnline,
      dateWhenLogOut: userEntity.dateWhenLogOut,
      isPrivate: userEntity.isPrivate,
    ).toSnapshot();
    try {
      userCollection.doc(userEntity.uid).get().then((docUser) {
        if (!docUser.exists) {
          userCollection.doc(userEntity.uid).set(newUser);
        } else {
          //userCollection.doc(uid).update(newUser);
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = store.collection(FirebaseCollectionConst.users);
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getSingleUserUid(String userUid) {
    final userCollection = store
        .collection(FirebaseCollectionConst.users)
        .where("uid", isEqualTo: userUid);
    return userCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signOut() async {
    try {
      if (PrefServices.getData(key: "uid") != null) {
        String userId = PrefServices.getData(key: "uid")!;
        FirebaseMessaging.instance.unsubscribeFromTopic("users");
        FirebaseMessaging.instance.unsubscribeFromTopic("users$userId");
        PrefServices.sharedPreferences!.clear();
        await store.collection("users").doc(userId).update({
          "isOnline": false,
          "dateWhenLogOut": DateTime.now(),
        });
        await auth.signOut();
        await GoogleSignIn().signOut();
        print("============================================");
        print("$userId   logOut");
        print("============================================");
      } else {
        showSnackBar("no user save");
      }
      //return userLogOut;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUserEntity(UserEntity userEntity) async {
    final userCollection = store.collection(FirebaseCollectionConst.users);

    Map<String, dynamic> info = {};

    if (userEntity.username != "" && userEntity.username != null)
      info['userName'] = userEntity.username;

    if (userEntity.bio != "" && userEntity.bio != null)
      info['userName'] = userEntity.bio;

    if (userEntity.imageUrl != "" && userEntity.imageUrl != null)
      info['profileUrl'] = userEntity.imageUrl;

    if (userEntity.isOnline != null) info['isOnline'] = userEntity.isOnline;

    userCollection.doc(userEntity.uid).update(info);
  }

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await store
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        if (value.data() != null) {
          var data = value.data()!;
          PrefServices.saveData(key: 'uid', value: data['uid'].toString());
          String? userId = PrefServices.getData(key: "uid");
          FirebaseMessaging.instance.subscribeToTopic("users");
          FirebaseMessaging.instance.subscribeToTopic("users$userId");
          print("============================================login");
          print("$userId   login");
          print("============================================login");
          var updateUser =
              FirebaseFirestore.instance.collection("users").doc(data["uid"]);
          await updateUser.update({"isOnline": true});
        }
      });
      await store
          .collection("users")
          .doc(auth.currentUser?.uid)
          .update({"isOnline": true});
      return credential;
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.code);
      throw Exception(e.code);
    } catch (e) {
      showSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserCredential> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final user = await auth.signInWithCredential(credential);
      await store
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        if (value.data() != null) {
          var data = value.data()!;
          PrefServices.saveData(key: 'uid', value: data['uid'].toString());
          String? userId = PrefServices.getData(key: "uid");
          FirebaseMessaging.instance.subscribeToTopic("users");
          FirebaseMessaging.instance.subscribeToTopic("users$userId");
          print("============================================login");
          print("$userId   login");
          print("============================================login");
          var updateUser =
              FirebaseFirestore.instance.collection("users").doc(data["uid"]);
          await updateUser.update({"isOnline": true});
        }
      });
      await store
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"isOnline": true});
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String bio,
    required Uint8List image,
  }) async {
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showSnackBar(e.code);
      throw Exception(e.code);
    } catch (e) {
      showSnackBar(e.toString());
      throw Exception(e.toString());
    }
  }
}
