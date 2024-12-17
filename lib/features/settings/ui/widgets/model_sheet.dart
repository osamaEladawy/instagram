import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inistagram/core/class/responsive_screen.dart';
import 'package:inistagram/core/const/colors%20copy.dart';
import 'package:inistagram/core/functions/extinctions.dart';
import 'package:inistagram/translations/locale_keys.g.dart';

class ShowMyLanguage extends StatelessWidget {
  const ShowMyLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveScreen.initialize(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: ResponsiveScreen.width * 0.70,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.blueGrey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
             "",
              style: const TextStyle(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: () {
              //LangCubit.instance.changeLanguage("ar");
              // context.setLocale(const Locale("ar"));
              //context.pop();
            },
            //child: CustomContainer(title: LocaleKeys.arabic.tr()),
          ),
          SizedBox(height: 10.r),
          InkWell(
            onTap: () {
            //  LangCubit.instance.changeLanguage("en");
              // context.setLocale(const Locale("en"));
             // context.pop();
            },
            // child: CustomContainer(
            //   title: LocaleKeys.english.tr(),
            // ),
          ),
        ],
      ),
    );
  }
}
