import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:inistagram/app/riles/domain/entities/riles_entity.dart';
import 'package:inistagram/app/riles/domain/entities/riles_image_entity.dart';
import 'package:inistagram/app/riles/domain/use_cases/get_my_riles_future_usecase.dart';
import 'package:inistagram/app/riles/presentation/manager/get_my_riles/cubit/get_my_riles_cubit.dart';
import 'package:inistagram/app/riles/presentation/manager/riles/cubit/riles_cubit.dart';
import 'package:inistagram/app/riles/presentation/widgets/riles_dotted_borders_widget.dart';
import 'package:inistagram/app/user/domain/entities/user_entity.dart';
import 'package:inistagram/core/class/handel_request.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/globel/widgets/profile_widget.dart';
import 'package:inistagram/core/globel/widgets/sigle_chate/show_image_and_video.dart';
import 'package:inistagram/core/theme/style.dart';
import 'package:inistagram/storage/storage_provider.dart';
import 'package:inistagram/views/screens/home.dart';
import 'package:path/path.dart' as path;
import 'package:inistagram/main_injection_container.dart' as di;
import 'package:provider/provider.dart';

import '../../../../data/model/relis_model.dart';


class RilesPage extends StatefulWidget {
  final UserEntity currentUser;
  const RilesPage({super.key, required this.currentUser});

  @override
  State<RilesPage> createState() => _RilesPageState();
}

class _RilesPageState extends State<RilesPage> {
  List<RilesImageEntity> _stories = [];

  List<StoryItem> myStories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes;


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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RilesCubit>(context)
        .getStRiles(status: const RilesEntity());

    BlocProvider.of<GetMyRilesCubit>(context)
        .getMyStatus(uid: widget.currentUser.uid!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di
          .sl<GetMyRilesFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty && myStatus.first.stories != null) {
          _fillMyStoriesList(myStatus.first);
        }
      });
    });
  }

  Future _fillMyStoriesList(RilesEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (RilesImageEntity story in status.stories!) {
        myStories.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
      setState(() {});
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:BlocBuilder<RilesCubit, RilesState>(
      builder: (context, state) {
        if (state is RilesLoaded) {
          final statuses = state.riles
              //.where((element) => element.uid != widget.currentUser.uid)
              .toList();
          print("statuses loaded $statuses");

          return BlocBuilder<GetMyRilesCubit, GetMyRilesState>(
            builder: (context, state) {
              if (state is GetMyRilesLoaded) {
                print("loaded my status ${state.myRiles}");
                return _bodyWidget(statuses, widget.currentUser,
                    myRiles: state.myRiles);
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: tabColor,
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      },
    )));
  }

  _bodyWidget(List<RilesEntity> riles, UserEntity currentUser,
      {RilesEntity? myRiles}) {
    return 
    // Row(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Stack(
    //           children: [
    //             myRiles != null
    //                 ? GestureDetector(
    //                     onTap: () {
    //                       _eitherShowOrUploadSheet(myRiles, currentUser);
    //                     },
    //                     child: Container(
    //                       width: 55,
    //                       height: 55,
    //                       margin: const EdgeInsets.all(12.5),
    //                       child: CustomPaint(
    //                         painter: RilesDottedBordersWidget(
    //                             isMe: true,
    //                             numberOfStories: myRiles.stories!.length,
    //                             spaceLength: 4,
    //                             images: myRiles.stories!,
    //                             uid: widget.currentUser.uid),
    //                         child: Container(
    //                           margin: const EdgeInsets.all(3),
    //                           width: 55,
    //                           height: 55,
    //                           child: ClipRRect(
    //                             borderRadius: BorderRadius.circular(30),
    //                             child:
    //                                 profileWidget(imageUrl: myRiles.imageUrl),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 : Container(
    //                     margin: const EdgeInsets.symmetric(
    //                         horizontal: 10, vertical: 10),
    //                     width: 60,
    //                     height: 60,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(30),
    //                       child: profileWidget(),
    //                     ),
    //                   ),
    //             myRiles != null
    //                 ? Container()
    //                 : Positioned(
    //                     right: 10,
    //                     bottom: 8,
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         _eitherShowOrUploadSheet(myRiles, currentUser);
    //                       },
    //                       child: Container(
    //                         width: 25,
    //                         height: 25,
    //                         decoration: BoxDecoration(
    //                             color: tabColor,
    //                             borderRadius: BorderRadius.circular(25),
    //                             border: Border.all(
    //                                 width: 2, color: backgroundColor)),
    //                         child: const Center(
    //                           child: Icon(
    //                             Icons.add,
    //                             size: 20,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //           ],
    //         ),
    //         const Padding(
    //           padding: EdgeInsets.only(left: 10.0),
    //           child: Text(
    //             "Srories",
    //             style: TextStyle(
    //                 fontSize: 15,
    //                 color: greyColor,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             Navigator.pushNamed(context, PageConst.myStatusPage,
    //                 arguments: myRiles);
    //           },
    //           child: Icon(
    //             Icons.more_horiz,
    //             color: greyColor.withOpacity(.5),
    //           ),
    //         ),
    //       ],
    //     ),
    //     Expanded(
    //       //width: 500,
    //       //height: 100,
    //       child: GridView.builder(
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    //         //scrollDirection: Axis.horizontal,
    //         itemCount: riles.length,
    //         //shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           final status = riles[index];

    //           List<StoryItem> stories = [];

    //           for (RilesImageEntity storyItem in status.stories!) {
    //             stories.add(
    //               StoryItem(
    //                 url: storyItem.url!,
    //                 viewers: storyItem.viewers,
    //                 type: StoryItemTypeExtension.fromString(storyItem.type!),
    //               ),
    //             );
    //           }

    //           return InkWell(
    //             onTap: () {
    //               _showStatusImageViewBottomModalSheet(
    //                   status: status, stories: stories);
    //             },
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 SizedBox(
    //                   width: 55,
    //                   height: 55,
    //                   child: CustomPaint(
    //                     painter: RilesDottedBordersWidget(
    //                         isMe: false,
    //                         numberOfStories: status.stories!.length,
    //                         spaceLength: 4,
    //                         images: status.stories,
    //                         uid: widget.currentUser.uid),
    //                     child: Container(
    //                       margin: const EdgeInsets.all(3),
    //                       width: 55,
    //                       height: 55,
    //                       child: ClipRRect(
    //                         borderRadius: BorderRadius.circular(30),
    //                         child: profileWidget(imageUrl: status.imageUrl),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Text(
    //                   "${status.username}",
    //                   style: const TextStyle(fontSize: 16),
    //                 ),
    //                 //Text(formatDateTime(status.createdAt!.toDate())),
    //               ],
    //             ),
    //           );
    //         },
    //         // separatorBuilder: (BuildContext context, int index) =>
    //         //     const SizedBox(width: 12),
    //       ),
    //     )
    //   ],
    // );
         StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Riles").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return HandelRequest(
                snapshot: snapshot,
                widget: GridView.builder(
                   itemCount: snapshot.data?.docs.length,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot snap = snapshot.data!.docs[index];
                      RilesModel riles = RilesModel.fromSnapshot(snap);
                      return  Card(
                        child: Image.network("${riles.rilesUrl}")
                      );
                    }),
              );
            }
    );
  }

  Future _showStatusImageViewBottomModalSheet(
      {RilesEntity? status, required List<StoryItem> stories}) async {
    print("stories $stories");
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return FlutterStoryView(
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: stories,
          enableOnHoldHide: false,
          caption: "This is very beautiful photo",
          onPageChanged: (index) {
            BlocProvider.of<RilesCubit>(context).seenStatusUpdate(
                imageIndex: index,
                userId: widget.currentUser.uid!,
                statusId: status.statusId!);
          },
          createdAt: status!.createdAt!.toDate(),
        );
      },
    );
  }

  _uploadImageStatus(UserEntity currentUser) {
    var service =
        Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
    service
        .uploadStatuses(
            files: _selectedMedia!, onComplete: (onCompleteStatusUpload) {})
        .then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(RilesImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .sl<GetMyRilesFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<RilesCubit>(context)
              .updateOnlyImageStatus(
                  status: RilesEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          });
        } else {
          BlocProvider.of<RilesCubit>(context)
              .createStatus(
            status: RilesEntity(
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

  void _eitherShowOrUploadSheet(
      RilesEntity? myStatus, UserEntity currentUser) {
    if (myStatus != null) {
      _showStatusImageViewBottomModalSheet(
          status: myStatus, stories: myStories);
    } else {
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
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      );
    }
  }



}
