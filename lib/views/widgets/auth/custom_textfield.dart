import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final void Function()? onPressed;
  final double? height;
  final IconData? icon;
  final bool? obscureText;

  const CustomTextField(
      {super.key,
      this.hintText,
      this.labelText,
      this.controller,
      this.height = 50,
      this.icon,
      this.onPressed,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obscureText == null || obscureText == false ? true : false,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter this field";
          }
        },
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(icon,color: obscureText == true ? Colors.blue :null,)
          ),
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          filled: true,
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final void Function()? onPressed;
  final double? height;
  final IconData? icon;
  final bool? obscureText;

  const CustomTextFormField(
      {super.key,
      this.hintText,
      this.labelText,
      this.controller,
      this.height = 50,
      this.icon,
      this.onPressed,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 5,
      obscureText:obscureText == null || obscureText == false ? true : false,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter this field";
        }
      },
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(icon,color: obscureText == true ? Colors.blue : null,),
        ),
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        filled: true,
      ),
    );
  }
}

class CustomTextFormFieldPost extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final void Function()? onPressed;
  final double? height;
  final IconData? icon;
  final bool? obscureText;
  final int? maxLines;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormFieldPost(
      {super.key,
      this.hintText,
      this.labelText,
      this.controller,
      this.height = 50,
      this.icon,
      this.onPressed,
      this.obscureText,
      this.maxLines,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     return "Enter this field";
      //   }
      // },
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        hintText: hintText,
        labelText: labelText,
        border: InputBorder.none,
      ),
    );
  }
}
