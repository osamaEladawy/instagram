import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToFirebase({required Uint8List file}) async {
  final ref = FirebaseStorage.instance
      .ref()
      .child("profile/${DateTime.now().millisecondsSinceEpoch}");

  UploadTask uploadTask = ref.putData(
    file,
    SettableMetadata(contentType: 'image/png'),
  );
  TaskSnapshot snapshot = await uploadTask;
  String urlImage = await snapshot.ref.getDownloadURL();

  return urlImage;
}
