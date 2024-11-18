import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/responsive_screen.dart';
import 'package:inistagram/core/const/page_const.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/core/functions/snackbar.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/views/widgets/auth/custom_button.dart';
import 'package:inistagram/views/widgets/auth/custom_textfield.dart';

import '../../../../views/widgets/auth/dialog.dart';
import '../../../../views/widgets/auth/have_account_or_not.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveScreen.initialize(context);
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (b, s) {
          showDialog(
            context: context,
            builder: (context) => const MyDialog(),
          );
        },
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.pushNamed(PageConst.initialPage);
            } else if (state is LoginFailure) {
              showSnackBar("error");
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Container(
                padding: ResponsiveScreen.width > 600
                    ? EdgeInsets.symmetric(
                        horizontal: ResponsiveScreen.width / 3)
                    : EdgeInsets.symmetric(horizontal: 10.w),
                child: Form(
                  // key: AuthCubit.instance.myKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Instagram",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        obscureText: true,
                        controller: AuthCubit.instance.emailLogin,
                        hintText: "Enter your email address",
                        labelText: "Email",
                        icon: Icons.email,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        obscureText: AuthCubit.instance.isShowPasswordLogin,
                        onPressed: () {
                          AuthCubit.instance.showPasswordLogin();
                        },
                        controller: AuthCubit.instance.passwordLogin,
                        hintText: "Enter your password",
                        labelText: "password",
                        icon: Icons.visibility,
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            await AuthCubit.instance.forgetPassword();
                          },
                          child: Text(
                            "Forget password?",
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomMyButton(
                        color: Colors.blue,
                        title: "Login",
                        onPressed: () async {
                          await AuthCubit.instance.login();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin:  EdgeInsets.only(bottom: 10.h),
        child: HaveAccountOrNot(
          onTap: onTap,
          title: "Don't have account ?",
        ),
      ),
    );
  }
}
