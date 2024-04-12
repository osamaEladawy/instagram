import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inistagram/view_model/auth/login.dart';
import 'package:inistagram/views/widgets/auth/custom_button.dart';
import 'package:inistagram/views/widgets/auth/custom_textfield.dart';

import '../../core/shared/constant.dart';
import '../widgets/auth/dialog.dart';
import '../widgets/auth/have_account_or_not.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel viewModel = LoginViewModel();

  @override
  void dispose() {
    super.dispose();
    viewModel.email.dispose();
    viewModel.password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (b) {
          showDialog(
            context: context,
            builder: (context) => const MyDialog(),
          );
        },
        child: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: viewModel.myKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Instagram",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    obscureText: true,
                    height: viewModel.email.text.isNotEmpty
                        ? SharedData().heightIsValid
                        : SharedData().heightIsNotValid,
                    controller: viewModel.email,
                    hintText: "Enter your email address",
                    labelText: "Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    obscureText: viewModel.isHide,
                    onPressed: () {
                      viewModel.changeState();
                      setState(() {});
                    },
                    height: viewModel.password.text.isNotEmpty
                        ? SharedData().heightIsValid
                        : SharedData().heightIsNotValid,
                    controller: viewModel.password,
                    hintText: "Enter your password",
                    labelText: "password",
                    icon: Icons.visibility,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        await viewModel.forgetPassword(context);
                      },
                      child: const Text(
                        "Forget password?",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomMyButton(
                    color: Colors.blue,
                    title: "Login",
                    onPressed: () async {
                      viewModel.login(context);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  HaveAccountOrNot(
                    onTap: widget.onTap,
                    title: "Don't have account ?",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
