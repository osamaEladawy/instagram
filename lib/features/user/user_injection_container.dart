import 'package:inistagram/features/user/domain/use_cases/auth/get_user_uid_use_case.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/login_google_use_case.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/login_use_cases.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/logout_use_cases.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/register_use_cases.dart';
import 'package:inistagram/features/user/domain/use_cases/user/create_user_usecases.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/cerdential/credential_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/user/user_cubit.dart';

import '../../main_injection_container.dart';
import 'data/remote/data_sources/user_imp_remote_data_source.dart';
import 'data/remote/data_sources/user_remote_data_sources.dart';
import 'data/repositories/user_repository_imp.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/credential/get_current_uid_usecasses.dart';
import 'domain/use_cases/credential/is_sign_in_usecases.dart';
import 'domain/use_cases/credential/sign_out_usecases.dart';
import 'domain/use_cases/user/get_all_users_usecases.dart';
import 'domain/use_cases/user/get_single_user_usecases.dart';
import 'domain/use_cases/user/update_user_usecases.dart';

Future<void> userInjectionContainer() async {
  // * CUBITS INJECTION

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      getCurrentUidUseCases: sl.call(),
      isSignInUseCases: sl.call(),
      signOutUseCases: sl.call(),
      createUserUseCase: sl.call(),
      getUserUidUseCase: sl.call(),
      loginUseCases: sl.call(),
      loginWithGoogleUseCase: sl.call(),
      registerUseCases: sl.call(),
    ),
  );

  sl.registerFactory<UserCubit>(() =>
      UserCubit(getAllUsersUseCases: sl.call(), updateUserUseCases: sl.call()));

  sl.registerFactory<GetSingleUserCubit>(
      () => GetSingleUserCubit(getSingleUserUseCases: sl.call()));

  sl.registerFactory<CredentialCubit>(() => CredentialCubit(
        createUserUseCases: sl.call(),
      ));

  // * USE CASES INJECTION

  sl.registerLazySingleton<GetCurrentUidUseCases>(
      () => GetCurrentUidUseCases(repository: sl.call()));

  sl.registerLazySingleton<IsSignInUseCases>(
      () => IsSignInUseCases(repository: sl.call()));

  sl.registerLazySingleton<SignOutUseCases>(
      () => SignOutUseCases(repository: sl.call()));

  sl.registerLazySingleton<CreateUserUseCase>(
      () => CreateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetAllUsersUseCases>(
      () => GetAllUsersUseCases(repository: sl.call()));

  sl.registerLazySingleton<UpdateUserUseCases>(
      () => UpdateUserUseCases(repository: sl.call()));

  sl.registerLazySingleton<GetSingleUserUseCases>(
      () => GetSingleUserUseCases(repository: sl.call()));

  sl.registerFactory<LoginUseCases>(
    () => LoginUseCases(
      auhRepository: sl.call(),
    ),
  );

        sl.registerFactory<LoginWithGoogleUseCase>(
    () => LoginWithGoogleUseCase(
      authRepository: sl.call(),
    ),
  );

  sl.registerFactory<RegisterUseCases>(
    () => RegisterUseCases(
      auhRepository: sl.call(),
    ),
  );
  sl.registerFactory<LogoutUseCases>(
    () => LogoutUseCases(
      auhRepository: sl.call(),
    ),
  );
  // sl.registerFactory<CreateUserUseCase>(
  //   () => CreateUserUseCase(userRepository: sl.call()),
  // );
  sl.registerFactory<GetUserUidUseCase>(
    () => GetUserUidUseCase(authRepository: sl.call()),
  );



  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImp(userRemoteDataSource: sl.call()));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserImpRemoteDataSource(
        auth: sl.call(),
        store: sl.call(),
      ));
}
