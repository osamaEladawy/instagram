import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      String folderName, String imageName, File file, bool isPost) async {
    Reference reference = _storage
        .ref()
        .child("$folderName/${DateTime.now().millisecondsSinceEpoch}")
        .child(imageName);
        
    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }


    UploadTask uploadTask = reference.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'image/png'),
    );

    // UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String urlImage = await snapshot.ref.getDownloadURL();
    return urlImage;
  }

  Future<String> uploadImage2(String imageName, File file, bool isPost) async {
    Reference reference = _storage
        .ref()
        .child(imageName)
        .child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'image/jpg'),
    );

    // UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String urlImage = await snapshot.ref.getDownloadURL();
    return urlImage;
  }

    Future<String> uploadVideo(String folderName, File file, bool isPost) async {
    Reference reference = _storage
        .ref()
        .child(folderName)
        .child(_auth.currentUser!.uid);
        
    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(
      await file.readAsBytes(),
      SettableMetadata(contentType: 'video/mp4'),
    );

    // UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String urlImage = await snapshot.ref.getDownloadURL();
    return urlImage;
  }

}
