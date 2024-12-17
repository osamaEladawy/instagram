import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/responsive_screen.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/core/functions/profile_widget.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/shared/widgets/stackforimageuser.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';

import '../widgets/auth/custom_button.dart';
import '../widgets/auth/custom_textfield.dart';
import '../widgets/auth/dialog.dart';
import '../widgets/auth/have_account_or_not.dart';

class SignUp extends StatelessWidget {
  final void Function()? onTap;

  const SignUp({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    //var service = Provider.of<HandleImage>(context);
    ResponsiveScreen.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Instagram",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            context.pushNamedAndRemoveUntil(PageConst.loginPage);
            showSnackBar("check your email  ");
          } else if (state is RegisterFailure) {
            showSnackBar("error registration ");
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (b, r) {
              showDialog(
                context: context,
                builder: (context) => const MyDialog(),
              );
            },
            child: Container(
              padding: ResponsiveScreen.width > 600
                  ? EdgeInsets.symmetric(horizontal: ResponsiveScreen.width / 3)
                  : EdgeInsets.symmetric(horizontal: 10.w),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: AuthCubit.instance.keyRegister,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageForUsers(
                            onTap: () async {
                              await AuthCubit.instance.pickImage();
                            },
                            child: profileImage(
                              imageUrl: AuthCubit.instance.imageUrl,
                              image: AuthCubit.instance.image,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            obscureText: true,
                            controller: AuthCubit.instance.bio,
                            hintText: "Enter your bio",
                            labelText: "Bio",
                            icon: Icons.edit,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            obscureText: true,
                            // height: viewModel.name.text.isNotEmpty
                            //     ? SharedData().heightIsValid
                            //     : SharedData().heightIsNotValid,
                            controller: AuthCubit.instance.name,
                            hintText: "Enter your name",
                            labelText: "Name",
                            icon: Icons.person,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            obscureText: true,
                            // height: viewModel.email.text.isNotEmpty
                            //     ? SharedData().heightIsValid
                            //     : SharedData().heightIsNotValid,
                            controller: AuthCubit.instance.emailRegister,
                            hintText: "Enter your email address",
                            labelText: "Email",
                            icon: Icons.email,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            obscureText: AuthCubit.instance.isShowPassword,
                            onPressed: () {
                              AuthCubit.instance.showPassword();
                            },
                            // height: viewModel.password.text.isNotEmpty
                            //     ? SharedData().heightIsValid
                            //     : SharedData().heightIsNotValid,
                            controller: AuthCubit.instance.passwordRegister,
                            hintText: "Enter your password",
                            labelText: "password",
                            icon: Icons.visibility,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            obscureText:
                                AuthCubit.instance.isShowConfirmPassword,
                            onPressed: () {
                              AuthCubit.instance.showConfirmPassword();
                            },
                            // height: AuthCubit.instance.confirmPassword.text.isNotEmpty
                            //     ? SharedData().heightIsValid
                            //     : SharedData().heightIsNotValid,
                            controller: AuthCubit.instance.confirmPassword,
                            hintText: "Enter your password again",
                            labelText: "confirm password",
                            icon: Icons.visibility,
                          ),
                          SizedBox(height: 15.h),
                          CustomMyButton(
                            color: Colors.blue,
                            title: "Sign Up",
                            onPressed: () async {
                              await AuthCubit.instance.register();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 7.h, top: 7.h),
        child: HaveAccountOrNot(
          onTap: onTap,
          title: "You have account ?",
        ),
      ),
    );
  }
}
