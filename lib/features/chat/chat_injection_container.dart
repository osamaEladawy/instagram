




import 'package:inistagram/features/chat/presentation/manager/chat/chat_cubit.dart';
import 'package:inistagram/features/chat/presentation/manager/message/message_cubit.dart';

import '../../main_injection_container.dart';
import 'data/remote/data_sources/chat_remote_data_source.dart';
import 'data/remote/data_sources/chat_remote_data_source_imp.dart';
import 'data/repositories/chat_repository_imp.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/use_cases/delete_message_usecase.dart';
import 'domain/use_cases/delete_my_chat_usecase.dart';
import 'domain/use_cases/get_messages_usecase.dart';
import 'domain/use_cases/get_my_chat_usecase.dart';
import 'domain/use_cases/seen_message_update_usecase.dart';
import 'domain/use_cases/send_message_usecase.dart';

Future<void> chatInjectionContainer() async {

  // * CUBITS INJECTION

  sl.registerFactory<ChatCubit>(() => ChatCubit(
      getMyChatUseCase: sl.call(),
      deleteMyChatUseCase: sl.call()
  ));

  sl.registerFactory<MessageCubit>(() => MessageCubit(
      getMessagesUseCase: sl.call(),
      deleteMessageUseCase: sl.call(),
      sendMessageUseCase: sl.call(),
      seenMessageUpdateUseCase: sl.call()
  ));


  // * USE CASES INJECTION


  sl.registerLazySingleton<DeleteMessageUseCase>(() => DeleteMessageUseCase(repository: sl.call()));

  sl.registerLazySingleton<DeleteMyChatUseCase>(
          () => DeleteMyChatUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetMessagesUseCase>(
          () => GetMessagesUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetMyChatUseCase>(
          () => GetMyChatUseCase(repository: sl.call()));

  sl.registerLazySingleton<SendMessageUseCase>(
          () => SendMessageUseCase(repository: sl.call()));

  sl.registerLazySingleton<SeenMessageUpdateUseCase>(
          () => SeenMessageUpdateUseCase(repository: sl.call()));



  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<ChatRepository>(
          () => ChatRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
    fireStore: sl.call(),
  ));

}