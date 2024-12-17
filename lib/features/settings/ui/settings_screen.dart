import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/responsive_screen.dart';
import 'package:inistagram/core/storage/pref_services.dart';
import 'package:inistagram/features/settings/cubit/settings_cubit.dart';
import 'package:inistagram/translations/locale_keys.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveScreen.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings",
          style: const TextStyle(
              //color: AppColors.whiteColor,
              ),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Container(
            color: PrefServices.getData(key: "dark") == true
                ? Colors.black
                : Colors.white,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                        height: ResponsiveScreen.width / 2, color: Colors.teal),
                    Positioned(
                      top: ResponsiveScreen.width / 2.5,
                      child: Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/images/person.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Card(
                  child: ListTile(
                    title: Text("theme"),
                    trailing: Switch(
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.white,
                      value: SettingsCubit.instance.changeStateForSwish(),
                      onChanged: (value) {
                        SettingsCubit.instance.toggleTheme(value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Card(
                //   child: ListTile(
                //     onTap: () {
                //       showModalBottomSheet(
                //           context: context,
                //           builder: (_) {
                //             return BlocBuilder<LangCubit, LangState>(
                //               builder: (context, state) {
                //                 return const ShowMyLanguage();
                //               },
                //             );
                //           });
                //     },
                //     title: Text(LocaleKeys.language.tr()),
                //     trailing: Icon(Icons.language, size: 23.sp),
                //   ),
                // ),
                // SizedBox(height: 5.h),
                // Card(
                //   child: ListTile(
                //     onTap: () {
                //       context.pushNamed(Routes.feedBack);
                //     },
                //     title: const Text("Feedback"),
                //     trailing: Icon(Icons.feedback, size: 23.sp),
                //   ),
                // ),
                // SizedBox(height: 5.h),
                // BlocConsumer<AuthCubit, AuthState>(
                //   listener: (context, state) {
                //     if (state is LogOutSuccess) {
                //       context.pushNamedAndRemoveUntil(Routes.splash);
                //     }
                //   },
                //   builder: (context, state) {
                //     return Card(
                //       child: ListTile(
                //         title: Text(LocaleKeys.logOut.tr()),
                //         trailing: IconButton(
                //           onPressed: () {
                //             AuthCubit.instance.logout();
                //           },
                //           icon: Icon(
                //             Icons.logout,
                //             size: 23.sp,
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
