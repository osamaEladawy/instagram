import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/shared/widgets/profile_widget.dart';
import 'package:inistagram/features/user/presentation/pages/initialpage.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:inistagram/main_injection_container.dart' as di;

import '../../../../core/const/page_const.dart';
import '../../../../shared/sigle_chate/show_image_and_video.dart';
import '../../../../core/providers/storage_provider.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/status_entity.dart';
import '../../domain/entities/status_image_entity.dart';
import '../../domain/use_cases/get_my_status_future_usecase.dart';
import '../manager/get_my_status/get_my_status_cubit.dart';
import '../manager/status/status_cubit.dart';
import '../widgets/status_dotted_borders_widget.dart';

class StatusPage extends StatefulWidget {
  final UserEntity currentUser;

  const StatusPage({super.key, required this.currentUser});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {

  List<StatusImageEntity> _stories = [];

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
    BlocProvider.of<StatusCubit>(context)
        .getStatuses(status: const StatusEntity());

    BlocProvider.of<GetMyStatusCubit>(context)
        .getMyStatus(uid: widget.currentUser.uid!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty && myStatus.first.stories != null) {
          _fillMyStoriesList(myStatus.first);
        }
      });
    });
  }

  Future _fillMyStoriesList(StatusEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (StatusImageEntity story in status.stories!) {
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
    print("build");
    return BlocBuilder<StatusCubit, StatusState>(
      builder: (context, state) {
        if (state is StatusLoaded) {
          final statuses = state.statuses
              .where((element) => element.uid != widget.currentUser.uid)
              .toList();
          print("statuses loaded $statuses");

          return BlocBuilder<GetMyStatusCubit, GetMyStatusState>(
            builder: (context, state) {
              if (state is GetMyStatusLoaded) {
                print("loaded my status ${state.myStatus}");
                return 
                _bodyWidget(statuses, widget.currentUser,
                    myStatus: state.myStatus);
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
    );
  }

  _bodyWidget(List<StatusEntity> statuses, UserEntity currentUser,
      {StatusEntity? myStatus}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                myStatus != null
                    ? GestureDetector(
                        onTap: () {
                          _eitherShowOrUploadSheet(myStatus, currentUser);
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          margin: const EdgeInsets.all(12.5),
                          child: CustomPaint(
                            painter: StatusDottedBordersWidget(
                                isMe: true,
                                numberOfStories: myStatus.stories!.length,
                                spaceLength: 4,
                                images: myStatus.stories!,
                                uid: widget.currentUser.uid),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 55,
                              height: 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child:
                                    profileWidget(imageUrl: myStatus.imageUrl),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(imageUrl: widget.currentUser.imageUrl),
                        ),
                      ),
                myStatus != null
                    ? Container()
                    : Positioned(
                        right: 10,
                        bottom: 8,
                        child: GestureDetector(
                          onTap: () {
                            _eitherShowOrUploadSheet(myStatus, currentUser);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: tabColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 2, color: backgroundColor)),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Stories",
                style: TextStyle(
                    fontSize: 15,
                    color: greyColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PageConst.myStatusPage,
                    arguments: myStatus);
              },
              child: Icon(
                Icons.more_horiz,
                color: greyColor.withOpacity(.5),
              ),
            ),
          ],
        ),
        SizedBox(
          //width: 500,
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: statuses.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final status = statuses[index];

              List<StoryItem> stories = [];

              for (StatusImageEntity storyItem in status.stories!) {
                stories.add(
                  StoryItem(
                    url: storyItem.url!,
                    viewers: storyItem.viewers,
                    type: StoryItemTypeExtension.fromString(storyItem.type!),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  _showStatusImageViewBottomModalSheet(
                      status: status, stories: stories);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CustomPaint(
                        painter: StatusDottedBordersWidget(
                            isMe: false,
                            numberOfStories: status.stories!.length,
                            spaceLength: 4,
                            images: status.stories,
                            uid: widget.currentUser.uid),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 55,
                          height: 55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: profileWidget(imageUrl: status.imageUrl),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${status.username}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    //Text(formatDateTime(status.createdAt!.toDate())),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 12),
          ),
        )
      ],
    );
  }

  Future _showStatusImageViewBottomModalSheet(
      {StatusEntity? status, required List<StoryItem> stories}) async {
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
            BlocProvider.of<StatusCubit>(context).seenStatusUpdate(
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
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                  status: StatusEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const InitialPage()));
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
                context, MaterialPageRoute(builder: (_) => const InitialPage()));
          });
        }
      });
    });
  }

  void _eitherShowOrUploadSheet(
      StatusEntity? myStatus, UserEntity currentUser) {
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
