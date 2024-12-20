// ignore_for_file: invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/core/functions/uni_list_storge.dart';
import 'package:inistagram/shared/sigle_chate/show_image_picked.dart';
import 'package:inistagram/shared/sigle_chate/show_video_picked.dart';
import 'package:inistagram/features/chat/presentation/widgets/single_chat/checks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/const/app_const.dart';
import '../../../../core/const/message_type_const.dart';
import '../../../../core/providers/storage_provider.dart';
import '../../../calls/presentation/pages/call_pick_up.dart';
import '../../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_replay_entity.dart';
import '../manager/message/message_cubit.dart';
import '../widgets/chat_utlis.dart';
import '../widgets/message/message_replay_preview_widget.dart';
import '../widgets/single_chat/appBar_single_chat_actions.dart';
import '../widgets/single_chat/appBar_single_chat_title.dart';
import '../widgets/single_chat/isshowattackwindow.dart';
import '../widgets/single_chat/listofmessage.dart';
import '../widgets/single_chat/possitioned.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;

  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();

  void _hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void _showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void _showKeyboard() => focusNode.requestFocus();

  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      _showKeyboard();
      _hideEmojiContainer();
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }

  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isDisplaySendButton = false;

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  bool _isShowAttachWindow = false;

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;


  Uint8List? file;
  void getImageForGallery() async {
    final image = await pickUpStorage(ImageSource.gallery);
    setState(() {
      file = image;
    });
  }

  String? audioFilePath;

  void pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: [
      //   'mp3',
      //   'wav',
      //   'ogg',
      //   // 'aac',
      //   // 'flac',
      // ], // Restrict to specific extensions
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        audioFilePath = file.path;
      });
    }
  }

  String? filePath;
  void pickDocument() async {
    // Use FilePicker to let user pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      // allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        filePath = file.path; // Get file path
      });
    } else {
      // User canceled the picker
      print("No file selected");
    }
  }

  Contact? selectedContact;

  // Function to pick a contact
  Future<void> pickContact() async {
    // Check and request permission
    if (await Permission.contacts.isDenied) await Permission.contacts.request();
    if (await Permission.contacts.request().isGranted) {
      // Fetch the contacts and let user pick one
      Iterable<Contact> contacts = await ContactsService.getContacts();
      Contact? contact = await showDialog<Contact>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Select a Contact'),
          children: contacts
              .map(
                (contact) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, contact),
                  child: Text(contact.displayName ?? 'No Name'),
                ),
              )
              .toList(),
        ),
      );

      if (contact != null) {
        setState(() {
          selectedContact = contact;
        });
      }
    } else {
      // Permission denied
      print("Contacts permission denied");
    }
  }

  GoogleMapController? mapController;
  LatLng _currentPosition =
      LatLng(37.7749, -122.4194); // Default location: San Francisco
  LatLng? _selectedLocation;

  // Function to get the user's current location
  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isDenied) await Geolocator.requestPermission();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    } else {
      print("Location permission denied");
    }
  }

  // Function to handle map tap (picking location)
  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  void initState() {
    _getUserLocation();
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.message.recipientUid!);

    BlocProvider.of<MessageCubit>(context).getMessages(
        message: MessageEntity(
            senderUid: widget.message.senderUid,
            recipientUid: widget.message.recipientUid));

    super.initState();
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  File? _image;

  Future selectImage() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  File? _imageGallery;

  Future selectImageFromGallery() async {
    setState(() => _imageGallery = null);
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageGallery = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  File? _video;

  Future selectVideo() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToBottom();
    });

    final provider = BlocProvider.of<MessageCubit>(context);

    bool _isReplying = provider.messageReplay.message != null;

    return PickUpCallPage(
      uid: widget.message.senderUid,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          centerTitle: false,
          title: AppBarSingleChatTitle(
            recipientName: '${widget.message.recipientName}',
          ),
          actions: [
            AppBarSingleChatActions(message: widget.message),
            SizedBox(width: 25.w),
            const Icon(Icons.call, size: 22),
            SizedBox(width: 25.w),
            const Icon(Icons.more_vert, size: 22),
            SizedBox(width: 15.w),
          ],
        ),
        body: BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            if (state is MessageLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
              final messages = state.messages;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isShowAttachWindow = false;
                  });
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ListOfMessages(
                          messages: messages,
                          focusNode: focusNode,
                          messageEntity: widget.message,
                          provider: provider,
                          scrollController: _scrollController,
                          recipientProfile: widget.message.recipientProfile,
                        ),
                        _isReplying == true
                            ? SizedBox(height: 5.h)
                            : SizedBox(height: 0),
                        _isReplying == true
                            ? Row(
                                children: [
                                  Expanded(
                                    child: MessageReplayPreviewWidget(
                                      onCancelReplayListener: () {
                                        provider.setMessageReplay =
                                            MessageReplayEntity();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Container(width: 60.w),
                                ],
                              )
                            : Container(),
                        ChecksAndConditions(
                          isReplying: _isReplying,
                          focusNode: focusNode,
                          isShowAttachWindow: _isShowAttachWindow,
                          isShowEmojiKeyboard: isShowEmojiKeyboard,
                          textMessageController: _textMessageController,
                          isDisplaySendButton: _isDisplaySendButton,
                          isRecording: _isRecording,
                          toggleEmojiKeyboard: toggleEmojiKeyboard,
                          sendTextMessage: () {
                            _sendTextMessage();
                          },
                          selectImage: () {
                            selectImage().then((value) {
                              if (_image != null) {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (timeStamp) {
                                    showImagePickedBottomModalSheet(context,
                                        recipientName:
                                            widget.message.recipientName,
                                        file: _image, onTap: () {
                                      _sendImageMessage();
                                      context.pop();
                                    });
                                  },
                                );
                              }
                            });
                          },
                          onChanged: (String value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _textMessageController.text = value;
                                _isDisplaySendButton = true;
                              });
                            } else {
                              setState(() {
                                _isDisplaySendButton = false;
                                _textMessageController.text = value;
                              });
                            }
                          },
                          showAttackAndEmoji: () {
                            setState(() {
                              _isShowAttachWindow = false;
                              isShowEmojiKeyboard = false;
                            });
                          },
                          changeStateAttackWindow: () {
                            setState(() {
                              _isShowAttachWindow = !_isShowAttachWindow;
                            });
                          },
                        ),
                        isShowEmojiKeyboard
                            ? IsShowAttackWindow(
                                onTap: () {
                                  setState(() {
                                    _textMessageController.text =
                                        _textMessageController.text.substring(
                                            0,
                                            _textMessageController.text.length -
                                                2);
                                  });
                                },
                                onEmojiSelected: ((category, emoji) {
                                  setState(() {
                                    _textMessageController.text =
                                        _textMessageController.text +
                                            emoji.emoji;
                                  });
                                }),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    _isShowAttachWindow == true
                        ? MyPosition(
                            getImageFromCamera: () {},
                            getLocation: () async{
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      child: Container(
                                        //height: 200.h,
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: _currentPosition,
                                            zoom: 15.0,
                                          ),
                                          onMapCreated: (controller) {
                                            mapController = controller;
                                          },
                                          onTap: _onMapTapped,
                                          markers: _selectedLocation != null
                                              ? {
                                                  Marker(
                                                    markerId: MarkerId(
                                                        'selected-location'),
                                                    position:
                                                        _selectedLocation!,
                                                  ),
                                                }
                                              : {},
                                        ),
                                      ),
                                    );
                                  });
                            },
                            getContact: () async {
                              await pickContact();
                            },
                            getAudio: () async {
                              pickAudio();
                            },
                            getDoc: () async {
                              pickDocument();
                            },
                            getImageFromGallery: () async {
                              getImageForGallery();
                            },
                            sendGifMessage: () {
                              _sendGifMessage();
                            },
                            selectVideo: () {
                              selectVideo().then((value) {
                                if (_video != null) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (timeStamp) {
                                      showVideoPickedBottomModalSheet(context,
                                          recipientName:
                                              widget.message.recipientName,
                                          file: _video, onTap: () {
                                        _sendVideoMessage();
                                        context.pop();
                                      });
                                    },
                                  );
                                }
                              });
                              setState(() {
                                _isShowAttachWindow = false;
                              });
                            },
                          )
                        : Container()
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: tabColor),
            );
          },
        ),
      ),
    );
  }

  _sendTextMessage() async {
    final provider = BlocProvider.of<MessageCubit>(context);

    if (_isDisplaySendButton || _textMessageController.text.isNotEmpty) {
      if (provider.messageReplay.message != null) {
        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage,
            repliedMessage: provider.messageReplay.message,
            repliedTo: provider.messageReplay.username,
            repliedMessageType: provider.messageReplay.messageType);
      } else {
        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage);
      }

      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        _textMessageController.clear();
      });
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }

      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        var service = Provider.of<StorageProviderRemoteDataSource>(context,
            listen: false);
        service
            .uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: widget.message.senderUid,
          otherUid: widget.message.recipientUid,
          type: MessageTypeConst.audioMessage,
        )
            .then((audioUrl) {
          _sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder!.startRecorder(
          toFile: audioPath,
        );
      }

      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  void _sendImageMessage() {
    var service =
        Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
    service
        .uploadMessageFile(
      file: _image!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.photoMessage,
    )
        .then((photoImageUrl) {
      _sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    var service =
        Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
    service
        .uploadMessageFile(
      file: _video!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.videoMessage,
    )
        .then((videoUrl) {
      _sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }

  Future _sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(message: fixedUrl, type: MessageTypeConst.gifMessage);
    }
  }

  void _sendMessage({
    required String message,
    required String type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType,
  }) {
    _scrollToBottom();

    ChatUtils.sendMessage(
      context,
      messageEntity: widget.message,
      message: message,
      type: type,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
      repliedMessage: repliedMessage,
    ).then((value) {
      _scrollToBottom();
    });
  }
}
