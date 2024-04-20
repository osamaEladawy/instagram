import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/app/calls/presentation/manager/call/call_cubit.dart';
import 'package:inistagram/app/riles/presentation/manager/get_my_riles/cubit/get_my_riles_cubit.dart';
import 'package:inistagram/app/riles/presentation/manager/riles/cubit/riles_cubit.dart';
import 'package:inistagram/app/status/presentation/manager/get_my_status/get_my_status_cubit.dart';
import 'package:inistagram/app/status/presentation/manager/status/status_cubit.dart';
import 'package:inistagram/routes/on_generate_routes.dart';
import 'package:inistagram/storage/storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/calls/presentation/manager/agora/agora_cubit.dart';
import 'app/calls/presentation/manager/my_call/my_call_history_cubit.dart';
import 'app/chat/presentation/manager/chat/chat_cubit.dart';
import 'app/chat/presentation/manager/message/message_cubit.dart';
import 'app/user/presentation/manager/auth/auth_cubit.dart';
import 'app/user/presentation/manager/cerdential/credential_cubit.dart';
import 'app/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'app/user/presentation/manager/user/user_cubit.dart';
import 'controller/auth_service.dart';
import 'controller/user_providers.dart';
import 'core/class/handle_image.dart';
import 'main_injection_container.dart' as di;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBKovNQMd5XnYIeAR058tvKroWWSCBu3vw",
        appId: "1:465195890091:android:09b5f0bf7ecc63716aceee",
        messagingSenderId: "465195890091",
        projectId: "inista-c71ef",
        storageBucket: "inista-c71ef.appspot.com"),
  );
  await di.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //110429901
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => HandleImage()),
        ChangeNotifierProvider(create: (context) => UsersProviders()),
        ChangeNotifierProvider(
            create: (context) => StorageProviderRemoteDataSource()),
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<CredentialCubit>()),
        BlocProvider(create: (context) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (context) => di.sl<UserCubit>()),
        BlocProvider(
          create: (context) => di.sl<ChatCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MessageCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<StatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetMyStatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CallCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MyCallHistoryCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AgoraCubit>(),
        ),
         BlocProvider(
          create: (context) => di.sl<GetMyRilesCubit>(),
        ),
         BlocProvider(
          create: (context) => di.sl<RilesCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.black),
          themeMode: ThemeMode.system,
         // home: const VideoPlayerScreen(),
      initialRoute: "/",
      onGenerateRoute: OnGenerateRoute.route,
    );
  }
}

