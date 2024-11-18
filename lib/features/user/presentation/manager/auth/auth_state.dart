part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Authenticated extends AuthState {
  final String userUid;
  const Authenticated({required this.userUid});
}

final class UnAuthenticated extends AuthState {}


final class ChangeColor extends AuthState {}

final class SelectImage extends AuthState {
  final Uint8List image;

  const SelectImage({required this.image});
}


final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  final UserCredential user;

  LoginSuccess({required this.user});
}

final class LoginFailure extends AuthState {}

final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {
  final UserCredential user;

  RegisterSuccess({required this.user});
}

final class RegisterFailure extends AuthState {}


final class LogOutSuccess extends AuthState {}

final class LogOutFailure extends AuthState {}


final class ShowPasswordConfirmation extends AuthState {
  final bool isShow;
  const ShowPasswordConfirmation({required this.isShow});
}

final class ShowPassword extends AuthState {
  final bool isShow;
  const ShowPassword({required this.isShow});
}

final class CreateUser extends AuthState {
  const CreateUser();
}


//login with google
final class LoginWithGoogleLoading extends AuthState {}

final class LoginWithGoogleSuccess extends AuthState {
  final UserCredential userCredential;

  const LoginWithGoogleSuccess({required this.userCredential});
}

final class LoginWithGoogleFailure extends AuthState {
  final String errorMessage;
  const LoginWithGoogleFailure({required this.errorMessage});
}

final class GetDataForUsersLoading extends AuthState {}
final class GetDataForUsersSuccess extends AuthState {
  final Map map;

  GetDataForUsersSuccess({required this.map});
}
final class GetDataForUsersFailure extends AuthState{}

final class GetPostsLoading extends AuthState {}
final class GetPostsSuccess extends AuthState {
  final Map map;

  GetPostsSuccess({required this.map});
}
final class GetPostsFailure extends AuthState{}

final class  PrivateProfile extends AuthState {
  final bool isPrivate;

  PrivateProfile({required this.isPrivate});
}

final class GetLengthenedUsers extends AuthState{
  final int  length;

  GetLengthenedUsers({required this.length});
}

final class FollowersUsers extends AuthState{
  final int  length;

  FollowersUsers({required this.length});
}
final class FollowingUsers extends AuthState{
  final int  length;

  FollowingUsers({required this.length});
}
final class IsFollowUsers extends AuthState{
  final bool  isFollow;

  IsFollowUsers({required this.isFollow});
}