// ignore_for_file: invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inistagram/features/chat/domain/entities/message_replay_entity.dart';
import 'package:inistagram/features/chat/presentation/manager/message/message_cubit.dart';
import 'package:inistagram/core/const/app_const.dart';

class ChatViewModel {
  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();

  void _hideEmojiContainer() {
    isShowEmojiKeyboard = false;
  }

  void _showEmojiContainer() {
    isShowEmojiKeyboard = true;
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

  final TextEditingController textMessageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  bool isDisplaySendButton = false;

  bool isShowAttachWindow = false;

  FlutterSoundRecorder? soundRecorder;

  final bool isRecording = false;

  bool isRecordInit = false;

  Future<void> scrollToBottom() async {
    if (scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await soundRecorder!.openRecorder();
    isRecordInit = true;
  }

  File? image;

  Future selectImage() async {
    image = null;
    //setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      //setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print("no image has been selected");
        }
      }
      //});
    } catch (e) {
      toast("some error occured $e");
    }
  }

  File? video;

  Future selectVideo() async {
    image = null;
    //setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.pickVideo(source: ImageSource.gallery);

      //setState(() {
      if (pickedFile != null) {
        video = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print("no image has been selected");
        }
      }
      //});
    } catch (e) {
      toast("some error occured $e");
    }
  }

  void onMessageSwipe(
      {String? message, String? username, String? type, bool? isMe, context}) {
    BlocProvider.of<MessageCubit>(context).setMessageReplay =
        MessageReplayEntity(
            message: message,
            username: username,
            messageType: type,
            isMe: isMe);
  }
}
