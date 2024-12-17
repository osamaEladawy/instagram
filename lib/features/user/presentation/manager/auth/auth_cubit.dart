import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/core/functions/uni_list_storge.dart';
import 'package:inistagram/core/functions/upload_image_to_Firebase.dart';
import 'package:inistagram/features/user/data/remote/models/user_model.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/get_user_uid_use_case.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/login_google_use_case.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/login_use_cases.dart';
import 'package:inistagram/features/user/domain/use_cases/auth/register_use_cases.dart';
import 'package:inistagram/features/user/domain/use_cases/user/create_user_usecases.dart';
import 'package:inistagram/my_app.dart';
import 'package:inistagram/features/user/presentation/widgets/auth/custom_dialog.dart';

import '../../../domain/use_cases/credential/get_current_uid_usecasses.dart';
import '../../../domain/use_cases/credential/is_sign_in_usecases.dart';
import '../../../domain/use_cases/credential/sign_out_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUseCases getCurrentUidUseCases;
  final IsSignInUseCases isSignInUseCases;
  final SignOutUseCases signOutUseCases;

  //
  final LoginUseCases loginUseCases;
  final RegisterUseCases registerUseCases;
  //final LogoutUseCases logoutUseCases;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final CreateUserUseCase createUserUseCase;
  final GetUserUidUseCase getUserUidUseCase;

  AuthCubit({
    required this.isSignInUseCases,
    required this.signOutUseCases,
    required this.getCurrentUidUseCases,
    required this.createUserUseCase,
    required this.getUserUidUseCase,
    required this.loginUseCases,
    required this.loginWithGoogleUseCase,
    required this.registerUseCases,
  }) : super(AuthInitial());

  static final AuthCubit _authCubit =
      BlocProvider.of(navigatorKey.currentContext!);
  static AuthCubit get instance => _authCubit;

  final TextEditingController emailLogin = TextEditingController();
  final TextEditingController passwordLogin = TextEditingController();

  final TextEditingController name = TextEditingController();
  final TextEditingController passwordRegister = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController emailRegister = TextEditingController();
  final TextEditingController bio = TextEditingController();
  // final keyLogin = GlobalKey<FormState>(debugLabel: "login");
  final keyRegister = GlobalKey<FormState>(debugLabel: 'register');

  bool isShowPasswordLogin = false;
  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  Uint8List? image;
  String? imageUrl = "";

  //profile
  var data = {};
  var post = {};
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollow = false;
  bool loading = false;
  String postId = '';
  late Timestamp time;
  bool value = false;

  void showPassword() {
    if (passwordRegister.text.trim().isNotEmpty) {
      isShowPassword = !isShowPassword;
      emit(ShowPassword(isShow: isShowPassword));
      emit(ChangeColor());
    }
  }

  void showPasswordLogin() {
    if (emailLogin.text.trim().isNotEmpty) {
      isShowPasswordLogin = !isShowPasswordLogin;
      emit(ShowPassword(isShow: isShowPasswordLogin));
      emit(ChangeColor());
    }
  }

  void showConfirmPassword() {
    if (confirmPassword.text.trim().isNotEmpty) {
      isShowConfirmPassword = !isShowConfirmPassword;
      emit(ShowPassword(isShow: isShowConfirmPassword));
      emit(ChangeColor());
    }
  }

  Future<void> pickImage() async {
    image = await pickStorage(ImageSource.gallery);
    imageUrl = await uploadImageToFirebase(file: image!);
    emit(SelectImage(image: image!));
  }

  login() async {
    if (emailLogin.text.trim().isNotEmpty &&
        passwordLogin.text.trim().isNotEmpty) {
      emit(LoginLoading());
      final result = await loginUseCases.call(
        email: emailLogin.text.trim(),
        password: passwordLogin.text.trim(),
      );
      emit(LoginSuccess(user: result));
      emailLogin.clear();
      passwordLogin.clear();
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginWithGoogleLoading());
    final result = await loginWithGoogleUseCase.call();
    await createUser(typeLogin: 'google');
    emit(LoginWithGoogleSuccess(userCredential: result));
  }

  register() async {
    if (passwordRegister.text.trim() == confirmPassword.text.trim()) {
      emit(RegisterLoading());
      final result = await registerUseCases.call(
        email: emailRegister.text.trim(),
        password: passwordRegister.text.trim(),
        name: name.text.trim(),
        bio: bio.text.trim(),
        image: image!,
      );
      print("Register is successfully");
      await createUser(typeLogin: 'Email And Password');
      print("created new user  is successfully");
      emit(RegisterSuccess(user: result));
      keyRegister.currentState?.reset();
      image == null;
      name.clear();
      emailRegister.clear();
      passwordRegister.clear();
      confirmPassword.clear();
      bio.clear();
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } else {
      showSnackBar("passwords not match!");
    }
  }

  Future createUser({required String typeLogin}) async {
    final userUid = await getUserUidUseCase.call();
    final user = typeLogin == "google"
        ? UserModel(
            uid: userUid,
            email: FirebaseAuth.instance.currentUser!.email,
            username: FirebaseAuth.instance.currentUser!.displayName,
            bio: "add your bio",
            imageUrl: FirebaseAuth.instance.currentUser!.photoURL,
            isOnline: true,
            dateWhenLogOut: DateTime.now(),
            following: [],
            followers: [],
            saves: [],
            isPrivate: false,
          )
        : UserModel(
            uid: userUid,
            email: emailRegister.text.trim(),
            username: name.text.trim(),
            bio: bio.text.trim(),
            imageUrl: imageUrl,
            isOnline: false,
            dateWhenLogOut: DateTime.now(),
            following: [],
            followers: [],
            saves: [],
            isPrivate: false,
          );

    await createUserUseCase.call(user);
    emit(const CreateUser());
  }

  Future<void> forgetPassword() async {
    if (emailLogin.text.isEmpty || emailLogin.text == "") {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => DialogForPassword(
          content: "please Enter your email",
          onPressed: () {
            context.pop();
          },
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailLogin.text);
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => DialogForPassword(
          content: "please check your gmail now",
          onPressed: () {
            context.pop();
          },
        ),
      );
    } catch (e) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => DialogForPassword(
          content: "This is not Gmail",
          onPressed: () {
            context.pop();
          },
        ),
      );
    }
  }

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUseCases.call();

      if (isSignIn) {
        final uid = await getCurrentUidUseCases.call();
        emit(Authenticated(userUid: uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUseCases.call();
      emit(Authenticated(userUid: uid));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCases.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  privateMyProfile(uid) async {
    value = !value;
    if (value) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "isPrivate": true,
      });
    } else {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "isPrivate": false,
      });
    }
    emit(PrivateProfile(isPrivate: value));
    emit(ChangeColor());
  }

  getPosts() async {
    emit(GetPostsLoading());
    try {
      await FirebaseFirestore.instance.collection("posts").get().then((value) {
        for (var element in value.docs) {
          post = element.data();
          print("post=============================post");
          print(post);
          print("post=============================post");
        }
      });
      emit(GetPostsSuccess(map: post));
    } catch (e) {
      emit(GetPostsFailure());
      // throw Exception(e.toString());
    }
  }

  getData(context, String uid) async {
    emit(GetDataForUsersLoading());
    try {
      var userSnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      var snapPost = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLength = snapPost.docs.length;
      emit(GetLengthenedUsers(length: postLength));
      userData = userSnap.data()!;
      emit(GetDataForUsersSuccess(map: userData));
      print("================================================");
      print(userData);
      print("================================================");
      followers = userSnap.data()!['followers'].length;
      emit(FollowersUsers(length: followers));
      following = userSnap.data()!['following'].length;
      emit(FollowingUsers(length: following));
      isFollow = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      emit(IsFollowUsers(isFollow: isFollow));
    } catch (e) {
      emit(GetDataForUsersFailure());
    }
  }

  changePhoto({userId}) async {
    image = await pickStorage(ImageSource.gallery);
    imageUrl = await uploadImageToFirebase(file: image!);
    emit(SelectImage(image: image!));
    if (FirebaseAuth.instance.currentUser!.uid == userId) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"imageUrl": imageUrl}).then((value) async {
        await FirebaseFirestore.instance
            .collection("posts")
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          print("loop for posts====================user");
          value.docs.forEach((e) async {
            var updatePost = e.data();
            await FirebaseFirestore.instance
                .collection("posts")
                .doc(updatePost['postId'])
                .update({
              "profileImage": imageUrl,
            });
            print("user update================================post");
          });
        });
        print("user update================================profile");
      });
    }
  }
}
