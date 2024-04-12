// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:inistagram/core/theme/style.dart';

class SaveDataForUser extends StatelessWidget {
  final bool isProfileUpdating;
  final void Function()? onTap;
  const SaveDataForUser(
      {super.key, required this.isProfileUpdating, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: tabColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isProfileUpdating == true
            ? const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                ),
              )
            : const Center(
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}
