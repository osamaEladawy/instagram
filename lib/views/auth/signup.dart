import 'package:flutter/material.dart';
import 'package:inistagram/core/class/handle_image.dart';
import 'package:inistagram/core/globel/widgets/profile_widget.dart';
import 'package:inistagram/core/globel/widgets/stackforimageuser.dart';
import 'package:inistagram/view_model/auth/signup.dart';
import 'package:provider/provider.dart';

import '../../core/shared/constant.dart';
import '../widgets/auth/custom_button.dart';
import '../widgets/auth/custom_textfield.dart';
import '../widgets/auth/dialog.dart';
import '../widgets/auth/have_account_or_not.dart';

class SignUp extends StatefulWidget {
  final void Function()? onTap;

  const SignUp({super.key, this.onTap});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpViewModel viewModel = SignUpViewModel();

  @override
  void dispose() {
    super.dispose();
    viewModel.name.dispose();
    viewModel.email.dispose();
    viewModel.password.dispose();
    viewModel.confirmPassword.dispose();
    viewModel.bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<HandleImage>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Instagram",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (b) {
          showDialog(
            context: context,
            builder: (context) => const MyDialog(),
          );
        },
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: viewModel.myKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageForUsers(
                        onTap: () async {
                          await service.getImage(context);
                        },
                        child: profileWidget(
                            imageUrl: service.url, image: service.file),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        obscureText: true,
                        controller: viewModel.bio,
                        hintText: "Enter your bio",
                        labelText: "Bio",
                        icon: Icons.edit,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        obscureText: true,
                        height: viewModel.name.text.isNotEmpty
                            ? SharedData().heightIsValid
                            : SharedData().heightIsNotValid,
                        controller: viewModel.name,
                        hintText: "Enter your name",
                        labelText: "Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(
                        height: 10,
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
                        height: 10,
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
                        height: 10,
                      ),
                      CustomTextField(
                        obscureText: viewModel.isHide,
                        onPressed: () {
                          viewModel.changeState();
                          setState(() {});
                        },
                        height: viewModel.confirmPassword.text.isNotEmpty
                            ? SharedData().heightIsValid
                            : SharedData().heightIsNotValid,
                        controller: viewModel.confirmPassword,
                        hintText: "Enter your password again",
                        labelText: "confirm password",
                        icon: Icons.visibility,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomMyButton(
                        color: Colors.blue,
                        title: "Sign Up",
                        onPressed: () {
                          viewModel.signUp(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 7,top: 7),
        child: HaveAccountOrNot(
          onTap: widget.onTap,
          title: "You have account ?",
        ),
      ),
    );
  }
}
