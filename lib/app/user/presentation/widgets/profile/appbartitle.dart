import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/app/user/domain/entities/user_entity.dart';
import 'package:inistagram/app/user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import 'package:inistagram/core/theme/style.dart';
import 'package:inistagram/view_model/profile/profile_view_model.dart';
import 'package:jiffy/jiffy.dart';

class AppBarTitleForProfile extends StatelessWidget {
  final ProfileViewModel model;
  final UserEntity? userEntity;
  const AppBarTitleForProfile(
      {super.key, required this.model, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${model.userData['username']}"),
        const SizedBox(
          width: 10,
        ),
         BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
            builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            return model.userData['uid'] == userEntity?.uid && state.userEntity.isOnline == true
                ? const Text(
                    "Online",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400,color:tabColor),
                  )
                :model.isFollow ? Text(
                    "last seen ${Jiffy.parse("${state.userEntity.dateWhenLogOut.toDate()}").fromNow()}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: tabColor,
                    ),
                  ):const SizedBox();
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
  }
}
