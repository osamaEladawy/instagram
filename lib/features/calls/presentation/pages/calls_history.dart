import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/const/colors.dart';

import '../../../../core/functions/data_formates.dart';
import '../../../../core/shared/widgets/profile_widget.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../manager/my_call/my_call_history_cubit.dart';

class CallHistoryPage extends StatelessWidget {
  final UserEntity currentUser;
  const CallHistoryPage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCallHistoryCubit, MyCallHistoryState>(
      builder: (context, myCallHistoryState) {
        if (myCallHistoryState is MyCallHistoryLoaded) {
          final callHistory = myCallHistoryState.myCallHistory;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    callHistory.isNotEmpty? "Recent" : "No Recent History",
                    style: const TextStyle(
                        fontSize: 15,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: callHistory.length,
                    itemBuilder: (context, index) {
                      final singleCallHistory = callHistory[index];
                      return ListTile(
                        leading: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: profileWidget(
                                imageUrl: singleCallHistory.callerId == currentUser.uid? singleCallHistory.receiverProfileUrl : singleCallHistory.callerProfileUrl),
                          ),
                        ),
                        title: Text(
                          "${singleCallHistory.callerId == currentUser.uid? singleCallHistory.receiverName  :singleCallHistory.callerName}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              singleCallHistory.callerId == currentUser.uid? Icons.call_made : Icons.call_received,
                              color: singleCallHistory.isMissed == true? Colors.red : Colors.green,
                              size: 19,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(formatDateTime(singleCallHistory.createdAt!.toDate())),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.call,
                          color: tabColor,
                        ),
                      );
                    }),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: tabColor,
              ),
            ),
          );
        }
      },
    );
  }
}