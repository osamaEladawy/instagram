import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:inistagram/features/comments/comments_injections.dart';
import 'package:inistagram/features/home/home_injections.dart';
import 'package:inistagram/features/notifications/notifications_injections.dart';
import 'package:inistagram/features/posts/posts_injections.dart';
import 'package:inistagram/features/riles/riles_injection_container.dart';
import 'package:inistagram/features/save_posts/saveposts_injections.dart';
import 'package:inistagram/features/search/search_injections.dart';
import 'package:inistagram/features/settings/settings_injections.dart';
import 'package:inistagram/features/status/status_injection_container.dart';

import 'features/calls/call_injection_container.dart';
import 'features/chat/chat_injection_container.dart';
import 'features/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);

  await userInjectionContainer();
  await chatInjectionContainer();
  await statusInjectionContainer();
  await callInjectionContainer();
  await rilesInjectionContainer();
  notificationInjection();
  searchInjection();
  settingInjection();
  postsInjections();
  commentsInjections();
  savePostsInjections();
  homeInjection();
}
