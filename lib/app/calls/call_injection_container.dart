



import 'package:inistagram/app/calls/presentation/manager/agora/agora_cubit.dart';
import 'package:inistagram/app/calls/presentation/manager/call/call_cubit.dart';
import 'package:inistagram/app/calls/presentation/manager/my_call/my_call_history_cubit.dart';

import '../../main_injection_container.dart';
import 'data/remote/data_sources/call_remote_data_source.dart';
import 'data/remote/data_sources/call_remote_data_source_imp.dart';
import 'data/repositories/call_repository_imp.dart';
import 'domain/repositories/call_repository.dart';
import 'domain/use_cases/end_call_usecase.dart';
import 'domain/use_cases/get_call_channel_id_usecase.dart';
import 'domain/use_cases/get_my_call_history_usecase.dart';
import 'domain/use_cases/get_user_calling_usecase.dart';
import 'domain/use_cases/make_call_usecase.dart';
import 'domain/use_cases/save_call_history_usecase.dart';
import 'domain/use_cases/update_call_history_usecase.dart';

Future<void> callInjectionContainer() async {

  // * CUBITS INJECTION

  sl.registerFactory<CallCubit>(() => CallCubit(
      endCallUseCase: sl.call(),
      getUserCallingUseCase: sl.call(),
      makeCallUseCase: sl.call(), saveCallHistoryUseCase: sl.call(),
      updateCallHistoryStatusUseCase: sl.call()
  ));

  sl.registerFactory<MyCallHistoryCubit>(() => MyCallHistoryCubit(
      getMyCallHistoryUseCase: sl.call()
  ));

  sl.registerLazySingleton<AgoraCubit>(() => AgoraCubit());



  // * USE CASES INJECTION

  sl.registerLazySingleton<GetMyCallHistoryUseCase>(
          () => GetMyCallHistoryUseCase(repository: sl.call()));

  sl.registerLazySingleton<EndCallUseCase>(
          () => EndCallUseCase(repository: sl.call()));

  sl.registerLazySingleton<SaveCallHistoryUseCase>(
          () => SaveCallHistoryUseCase(repository: sl.call()));

  sl.registerLazySingleton<MakeCallUseCase>(
          () => MakeCallUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetUserCallingUseCase>(
          () => GetUserCallingUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetCallChannelIdUseCase>(
          () => GetCallChannelIdUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateCallHistoryStatusUseCase>(
          () => UpdateCallHistoryStatusUseCase(repository: sl.call()));


  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<CallRepository>(
          () => CallRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<CallRemoteDataSource>(() => CallRemoteDataSourceImpl(
    fireStore: sl.call(),
  ));

}