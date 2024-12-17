import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/my_app.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static final NotificationsCubit _notificationsCubit =
      BlocProvider.of(navigatorKey.currentContext!);
  static NotificationsCubit get instance => _notificationsCubit;

  Stream<QuerySnapshot<Map<String, dynamic>>> showUsers(String uid) =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("notifications")
          .snapshots();
}
