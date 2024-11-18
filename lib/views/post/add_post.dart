import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:inistagram/features/status/domain/entities/status_entity.dart';
import 'package:inistagram/features/status/domain/entities/status_image_entity.dart';
import 'package:inistagram/features/status/domain/use_cases/get_my_status_future_usecase.dart';
import 'package:inistagram/features/status/presentation/manager/status/status_cubit.dart';
import 'package:inistagram/features/user/domain/entities/user_entity.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/shared/sigle_chate/show_image_and_video.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/core/providers/storage_provider.dart';
import 'package:inistagram/view_model/post/add_post_model.dart';
import 'package:inistagram/views/screens/home.dart';
import 'package:inistagram/views/widgets/auth/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../core/class/handle_image.dart';
import '../../core/class/firestore_methods.dart';
import '../../core/functions/navigationpage.dart';
import '../../core/functions/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:inistagram/main_injection_container.dart' as di;

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final AddPostModel _model = AddPostModel();
  List<StatusImageEntity> _stories = [];

  List<StoryItem> myStories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes;

  _uploadImageStatus(UserEntity currentUser) {
    var service =
        Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
    service
        .uploadStatuses(
            files: _selectedMedia!, onComplete: (onCompleteStatusUpload) {})
        .then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .sl<GetMyStatusFutureUseCase>()
          .call(FirebaseAuth.instance.currentUser!.uid)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                  status: StatusEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
            status: StatusEntity(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.username,
                uid: currentUser.uid,
                profileUrl: currentUser.imageUrl,
                imageUrl: statusImageUrls[0],
                email: currentUser.email),
          )
              .then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          });
        }
      });
    });
  }

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  void _eitherShowOrUploadSheet(
      StatusEntity? myStatus, UserEntity currentUser) {
    // if (myStatus != null) {
    //   // _showStatusImageViewBottomModalSheet(
    //   //     status: myStatus, stories: myStories);
    // } else {
      selectMedia().then(
        (value) {
          if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia!,
                  onTap: () {
                     _uploadImageStatus(currentUser);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          }
        },
      );
   // }
  }

  addPosts(
    String uid,
    String profileImage,
    String username,
    context,
  ) async {
    setState(() {
      _model.isPostOrRiles = true;
    });
    var service = Provider.of<HandleImage>(context, listen: false);
    if (_model.myKey.currentState!.validate()) {
      setState(() {
        _model.loading = true;
      });
      try {
        String res = await FireStoreMethods().uploadPost(uid, service.file!,
            _model.description.text, username, profileImage, context);
        if (res == "success") {
          showSnackBar("Posted");
          _model.description.clear();
          _model.clearFile(context);
          setState(() {
            _model.loading = false;
          });
          navigationNamePage(context, PageConst.initialPage);
        } else {
          setState(() {
            _model.loading = false;
          });
          showSnackBar(res);
        }
      } catch (e) {
        setState(() {
          _model.loading = false;
        });
        showSnackBar(e.toString());
      }
    } else {
      showSnackBar("not valid");
    }
  }

  addRiles(
    String uid,
    String profileImage,
    String username,
    context,
  ) async {
    setState(() {
      _model.isPostOrRiles = false;
    });
    var service = Provider.of<HandleImage>(context, listen: false);
    if (_model.myKey.currentState!.validate()) {
      setState(() {
        _model.loading = true;
      });
      try {
        String res = await FireStoreMethods().uploadRiles(
            uid: uid,
            username: username,
            description: _model.description.text,
            profileImage: profileImage,
            file: service.file!);
        if (res == "success") {
          showSnackBar("Piles is uploaded");
          _model.description.clear();
          _model.clearFile(context);
          setState(() {
            _model.loading = false;
          });
          navigationNamePage(context, PageConst.initialPage);
        } else {
          setState(() {
            _model.loading = false;
          });
          showSnackBar(res);
        }
      } catch (e) {
        setState(() {
          _model.loading = false;
        });
        showSnackBar(e.toString());
      }
    } else {
      showSnackBar("not valid");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _model.description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UsersProviders>(context).users;
    var service = Provider.of<HandleImage>(context);
    return service.file == null
        ? Center(
            child: IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 100,
                        child: AlertDialog(
                          title: const Text("Select Image or riles"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text("Image"),
                                onTap: () async {
                                  setState(() {
                                    _model.isPostOrRiles = true;
                                  });
                                  await service.getImageGallery();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(Icons.video_call),
                                title: const Text("Video"),
                                onTap: () async {
                                  setState(() {
                                    _model.isPostOrRiles = false;
                                  });
                                  //await selectMedia();
                                   await service.selectMedia(_selectedMedia,_mediaTypes);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.upload,
                size: 30,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  _model.clearFile(context);
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                _model.isPostOrRiles == true
                    ? TextButton(
                        onPressed: () async {
                          await addPosts("${user!.uid}", "${user.imageUrl}",
                              "${user.username}", context);
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          await addRiles("${user!.uid}", "${user.imageUrl}",
                              "${user.username}", context);
                        },
                        child: const Text(
                          "Riles",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
            body: Column(
              children: [
                _model.loading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (user != null)
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage("${user.imageUrl}"),
                      ),
                    Form(
                      key: _model.myKey,
                      child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: CustomTextFormFieldPost(
                          maxLines: 8,
                          controller: _model.description,
                          hintText: "write post...",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: service.file != null
                                  ? FileImage(
                                      service.file!,
                                    )
                                  : const AssetImage("assets/images/pro.png")
                                      as ImageProvider,
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
