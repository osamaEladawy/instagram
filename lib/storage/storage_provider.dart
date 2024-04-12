import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class StorageProviderRemoteDataSource extends ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  String? imageUrl;

  Future<String> uploadProfileImage(
      {required String userId,
      required File file,
      Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    final ref = _storage
        .ref()
        .child("profile/${DateTime.now().millisecondsSinceEpoch}");

      UploadTask uploadTask =  ref.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'image/png'),
    );
      TaskSnapshot snapshot = await uploadTask;
      String urlImage = await snapshot.ref.getDownloadURL();

     if (_auth.currentUser!.uid == userId) {
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"imageUrl": urlImage}).then((value) async {
          await _store
              .collection("posts")
              .where("uid", isEqualTo: _auth.currentUser!.uid)
              .get()
              .then((value) {
            print("loop for posts====================user");
            value.docs.forEach((e) async {
              var updatePost = e.data();
              await _store
                  .collection("posts")
                  .doc(updatePost['postId'])
                  .update({
                "profileImage": urlImage,
              });
              print("user update================================post");
            });
          });
          print("user update================================profile");
        });
      }
    onComplete(false);
    return urlImage;
  }

  Future<String> uploadStatus(
      {required File file, Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    Reference ref =
        _storage.ref().child("status/${DateTime.now().millisecondsSinceEpoch}");

      String id = const Uuid().v1();
      ref = ref.child(id);

    final uploadTask = ref.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'image/png'),
    );

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    onComplete(false);
    return await imageUrl;
  }

  Future<List<String>> uploadStatuses(
      {required List<File> files,
      Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    List<String> imageUrls = [];
    for (var i = 0; i < files.length; i++) {
      Reference ref = _storage
          .ref() 
          .child("status/${DateTime.now().millisecondsSinceEpoch}${i + 1}");

          

      final uploadTask = ref.putData(await files[i].readAsBytes(),
          SettableMetadata(contentType: 'image/png'));

      final imageUrl =
          (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      imageUrls.add(await imageUrl);
    }
    onComplete(false);
    return imageUrls;
  }

  Future<String> uploadMessageFile(
      {required File file,
      Function(bool isUploading)? onComplete,
      String? uid,
      String? otherUid,
      String? type}) async {
    onComplete!(true);

    final ref = _storage.ref().child(
        "message/$type/$uid/$otherUid/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'image/png'),
    );

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    onComplete(false);
    return await imageUrl;
  }



  Future<List<String>> uploadRiles(
      {required List<File> files,
      Function(bool isUploading)? onComplete}) async {
    onComplete!(true);

    List<String> imageUrls = [];
    for (var i = 0; i < files.length; i++) {
      Reference ref = _storage
          .ref() 
          .child("Riles/${DateTime.now().millisecondsSinceEpoch}${i + 1}");

          

      final uploadTask = ref.putData(await files[i].readAsBytes(),
          SettableMetadata(contentType: 'video/mp4'));

      final imageUrl =
          (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      imageUrls.add(await imageUrl);
    }
    onComplete(false);
    return imageUrls;
  }



}
