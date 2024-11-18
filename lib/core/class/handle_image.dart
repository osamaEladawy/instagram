import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'storaged_method.dart';
import 'package:path/path.dart' as path;


class HandleImage extends ChangeNotifier {
  File? file;
  String? url;
  Uint8List? fil;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  getImageGallery() async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.gallery);
    if (imageLocation != null) {
      file = File(imageLocation.path);

      //get image name by
      String imageName = basename(imageLocation.path);

      url = await StorageMethod()
          .uploadImage("profile", imageName, file!, false);
    }
    notifyListeners();
    
  }

  getImageCamera() async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.camera);
    if (imageLocation != null) {
      file = File(imageLocation.path);
      String imageName = basename(imageLocation.path);

      url = await StorageMethod().uploadImage(
        "profImages",
        imageName,
        file!,
        false,
      );
    }
    notifyListeners();
  }

    Future<void> selectMedia(selectedMedia,mediaTypes) async {
    //setState(() {
      selectedMedia = null;
      mediaTypes = null;
    //});
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        mediaTypes = List<String>.filled(selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < selectedMedia!.length; i++) {
          String extension =
              path.extension(selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            mediaTypes![i] = 'video';
          }
        }
        notifyListeners();
        //setState(() {});
        print("mediaTypes = $mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }


  getVideoGromGallary()async{
    ImagePicker pecker = ImagePicker();
    XFile? videoLocation = await pecker.pickVideo(source: ImageSource.gallery);
    if (videoLocation != null) {
      file = File(videoLocation.path);

       //String imageName = basename(videoLocation.path);

      url = await StorageMethod().uploadVideo(
        "Riles",
        file!,
        false,
      );
    }
    notifyListeners();
  }

  getImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("choose image"),
        content: SizedBox(
          height: 180,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  getImageCamera();
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  getImageGallery();
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Gallery"),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: 200,
                color: Colors.white60,
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object>? profileImage(bool isUser,
      [File? mayFile, String? imageUrl]) {
    if (isUser == true) {
      if (mayFile == null) {
        if (imageUrl == null || imageUrl == "") {
          return const AssetImage("assets/images/profile_default.png");
        } else {
          return NetworkImage(imageUrl);
        }
      } else {
        return FileImage(mayFile);
      }
    } else {
      if (file == null) {
        if (url == null || url == "") {
          return const AssetImage("assets/images/profile_default.png");
        } else {
          return NetworkImage("$url");
        }
      } else {
        return FileImage(file!);
      }
    }
  }

  clearImage() {
    file = null;
    notifyListeners();
  }

  updateImageGallery(userId, String imageFileUrl) async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.gallery);
    if (imageLocation != null) {
      file = File(imageLocation.path);

      //get image name by
      String imageName = basename(imageLocation.path);

      url = await StorageMethod()
          .uploadImage("profile", imageName, file!, false);

      if (_auth.currentUser!.uid == userId) {
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"imageUrl": url}).then((value) async {
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
                "profileImage": url,
              });
               print("user update================================post");
            });
            
          });
          print("user update================================profile");
        });
      }
    }
    notifyListeners();
  }

  updateImageCamera(userId, imageFileUrl) async {
    ImagePicker pecker = ImagePicker();
    XFile? imageLocation = await pecker.pickImage(source: ImageSource.camera);
    if (imageLocation != null) {
      file = File(imageLocation.path);
      String imageName = basename(imageLocation.path);

      url = await StorageMethod().uploadImage(
        "profile",
        imageName,
        file!,
        false,
      );
      if (_auth.currentUser!.uid == userId) {
        await _store
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({"imageUrl": url}).then((value) async {
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
                "profileImage": url,
              });
               print("user update================================post");
            });
          });
          print("user update================================profile");
        });
      }
    }
    notifyListeners();
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  updateImage(BuildContext context, userId, String imageFileUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("choose image"),
        content: SizedBox(
          height: 180,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  updateImageCamera(userId, imageFileUrl);
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  updateImageGallery(userId, imageFileUrl);
                  Navigator.of(context).maybePop();
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("Gallery"),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: 200,
                color: Colors.white60,
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
