import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/handle_image.dart';
import 'package:inistagram/core/providers/auth_service.dart';
import 'package:inistagram/core/providers/storage_provider.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/core/routes/on_generate_routes.dart';
import 'package:inistagram/features/calls/presentation/manager/agora/agora_cubit.dart';
import 'package:inistagram/features/calls/presentation/manager/call/call_cubit.dart';
import 'package:inistagram/features/calls/presentation/manager/my_call/my_call_history_cubit.dart';
import 'package:inistagram/features/chat/presentation/manager/message/message_cubit.dart';
import 'package:inistagram/features/riles/presentation/manager/get_my_riles/cubit/get_my_riles_cubit.dart';
import 'package:inistagram/features/riles/presentation/manager/riles/cubit/riles_cubit.dart';
import 'package:inistagram/features/status/presentation/manager/get_my_status/get_my_status_cubit.dart';
import 'package:inistagram/features/status/presentation/manager/status/status_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/user/user_cubit.dart';
import 'package:provider/provider.dart';
import 'features/chat/presentation/manager/chat/chat_cubit.dart';
import 'features/user/presentation/manager/cerdential/credential_cubit.dart';
import 'main_injection_container.dart' as di;

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthService()),
            ChangeNotifierProvider(create: (context) => HandleImage()),
            ChangeNotifierProvider(create: (context) => UsersProviders()),
            ChangeNotifierProvider(
                create: (context) => StorageProviderRemoteDataSource()),

            //*Bloc
            BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
            BlocProvider(create: (context) => di.sl<CredentialCubit>()),
            BlocProvider(create: (context) => di.sl<GetSingleUserCubit>()),
            BlocProvider(create: (context) => di.sl<UserCubit>()),
            BlocProvider(create: (context) => di.sl<ChatCubit>()),
            BlocProvider(create: (context) => di.sl<MessageCubit>()),
            BlocProvider(create: (context) => di.sl<StatusCubit>()),
            BlocProvider(create: (context) => di.sl<GetMyStatusCubit>()),
            BlocProvider(create: (context) => di.sl<CallCubit>()),
            BlocProvider(create: (context) => di.sl<MyCallHistoryCubit>()),
            BlocProvider(create: (context) => di.sl<AgoraCubit>()),
            BlocProvider(create: (context) => di.sl<GetMyRilesCubit>()),
            BlocProvider(create: (context) => di.sl<RilesCubit>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: ThemeData.dark().copyWith(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.black,
                  centerTitle: true,
                ),
                scaffoldBackgroundColor: Colors.black),
            themeMode: ThemeMode.system,
            initialRoute: "/",
            onGenerateRoute: OnGenerateRoute.route,
          ),
        );
      },
      // child:
    );
  }
}
