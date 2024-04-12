import 'package:flutter/material.dart';
import 'package:inistagram/core/theme/style.dart';

class ProfileItem extends StatelessWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  const ProfileItem(
      {super.key,
      this.title,
      this.description,
      this.icon,
      this.onTap,
      this.controller});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              width: 80,
              height: 80,
              child: Icon(
                icon,
                color: greyColor,
                size: 25,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: description!,
                        suffixIcon: const Icon(
                          Icons.edit_rounded,
                          color: tabColor,
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
