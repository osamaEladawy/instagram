import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/features/home_tap/cubit/home_tap_cubit.dart';
import 'package:inistagram/features/settings/cubit/settings_cubit.dart';

class HomeTapScreen extends StatelessWidget {
  const HomeTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTapCubit, HomeTapState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: HomeTapCubit.instance.currentIndex,
                onTap: (value) {
                  HomeTapCubit.instance.changePageController(value);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle),
                    label: 'Post',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.videocam_sharp),
                    label: 'riles',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
          body: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                HomeTapCubit.instance.changePage(page);
              },
              controller: HomeTapCubit.instance.controller,
              itemCount: HomeTapCubit.instance.pages.length,
              itemBuilder: (_, index) {
                return HomeTapCubit.instance.pages[index];
              }),
        );
      },
    );
  }
}
