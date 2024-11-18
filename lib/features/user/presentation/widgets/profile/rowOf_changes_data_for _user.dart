import 'package:flutter/material.dart';
import 'package:inistagram/core/const/colors.dart';



class ChangesOfDataForUsers extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final String? labelText;
  const ChangesOfDataForUsers({super.key, this.hintText, this.icon, this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Icon(
          icon,
          color: greyColor,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              labelText:labelText,
              suffixIcon: const Icon(
                Icons.edit,
                color: tabColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
