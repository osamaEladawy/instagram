



import 'package:inistagram/app/riles/data/remote/data_sources/status_remote_data_source.dart';
import 'package:inistagram/app/riles/data/remote/data_sources/status_remote_data_source_imp.dart';
import 'package:inistagram/app/riles/data/repositories/status_repository_imp.dart';
import 'package:inistagram/app/riles/domain/repositories/riles_repository.dart';
import 'package:inistagram/app/riles/domain/use_cases/create_riles_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/delete_riles_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/get_my_riles_future_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/get_my_riles_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/get_riles_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/seen_riles_update_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/update_only_image_riles_usecase.dart';
import 'package:inistagram/app/riles/domain/use_cases/update_riles_usecase.dart';
import 'package:inistagram/app/riles/presentation/manager/get_my_riles/cubit/get_my_riles_cubit.dart';
import 'package:inistagram/app/riles/presentation/manager/riles/cubit/riles_cubit.dart';

import '../../main_injection_container.dart';


Future<void> rilesInjectionContainer() async {

  // * CUBITS INJECTION

  sl.registerFactory<RilesCubit>(() => RilesCubit(
      createStatusUseCase: sl.call(),
      deleteStatusUseCase: sl.call(),
      getStatusesUseCase: sl.call(),
      updateStatusUseCase: sl.call(),
      updateOnlyImageStatusUseCase: sl.call(),
      seenStatusUpdateUseCase: sl.call()
  ));

  sl.registerFactory<GetMyRilesCubit>(() => GetMyRilesCubit(
    getMyStatusUseCase: sl.call(),
  ));

  // * USE CASES INJECTION

  sl.registerLazySingleton<GetMyRilesUseCase>(
          () => GetMyRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateOnlyImageRilesUseCase>(
          () => UpdateOnlyImageRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetMyRilesFutureUseCase>(
          () => GetMyRilesFutureUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetRilesUseCase>(
          () => GetRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<DeleteRilesUseCase>(
          () => DeleteRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateRilesUseCase>(
          () => UpdateRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<CreateRilesUseCase>(
          () => CreateRilesUseCase(repository: sl.call()));

  sl.registerLazySingleton<SeenRilesUpdateUseCase>(
          () => SeenRilesUpdateUseCase(repository: sl.call()));

  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<RilesRepository>(
          () => RilesRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<RilesRemoteDataSource>(() => RilesRemoteDataSourceImpl(
    fireStore: sl.call(),
  ));
}