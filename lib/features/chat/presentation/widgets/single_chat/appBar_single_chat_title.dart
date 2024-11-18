import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/const/colors.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';

class AppBarSingleChatTitle extends StatelessWidget {
  final String recipientName;
  const AppBarSingleChatTitle({super.key, required this.recipientName});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UsersProviders>(context).users;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(recipientName),
        BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
            builder: (context, state) {
          if (state is GetSingleUserLoaded) {
            return state.userEntity.uid == user?.uid && user?.isOnline == true
                ? const Text(
                    "Online",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: greyColor),
                  )
                : Text(
                    "last seen ${Jiffy.parse("${state.userEntity.dateWhenLogOut.toDate()}").fromNow()}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: greyColor,
                    ),
                  );
          }

          return Container();
        }),
      ],
    );
  }
}
