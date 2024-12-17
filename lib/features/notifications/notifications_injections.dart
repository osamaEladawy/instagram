import 'package:inistagram/features/notifications/cubit/notifications_cubit.dart';
import 'package:inistagram/main_injection_container.dart';

void notificationInjection() {
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit());
}
