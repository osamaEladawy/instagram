import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/features/user/domain/entities/user_entity.dart';
import 'package:inistagram/features/user/presentation/manager/auth/auth_cubit.dart';
import 'package:inistagram/features/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:jiffy/jiffy.dart';

class AppBarTitleForProfile extends StatelessWidget {
  final UserEntity? userEntity;
  const AppBarTitleForProfile({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Row(
          children: [
            Text("${AuthCubit.instance.userData['username']}"),
            SizedBox(width: 10.w),
            BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
                builder: (context, state) {
              if (state is GetSingleUserLoaded) {
                return AuthCubit.instance.userData['uid'] == userEntity?.uid &&
                        state.userEntity.isOnline == true
                    ? const Text(
                        "Online",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: tabColor),
                      )
                    : AuthCubit.instance.isFollow
                        ? Text(
                            "last seen ${Jiffy.parse("${state.userEntity.dateWhenLogOut.toDate()}").fromNow()}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: tabColor,
                            ),
                          )
                        : const SizedBox();
              }

              return Container();
            }),
            // (model.userData['uid'] == userEntity?.uid && userEntity?.isOnline== true)
            //     ? const Text(
            //         "online",
            //         style: TextStyle(
            //           fontSize: 15,
            //           color: tabColor,
            //         ),
            //       )
            //     : Text(
            //         model.isFollow
            //             ? "offline ${Jiffy.parse((userEntity != null) ? "${userEntity!.dateWhenLogOut.toDate()}" : "offline").fromNow()}"
            //             : "",
            //         style: const TextStyle(
            //           fontSize: 15,
            //           color: tabColor,
            //         ),
            //       ),
          ],
        );
      },
    );
  }
}
