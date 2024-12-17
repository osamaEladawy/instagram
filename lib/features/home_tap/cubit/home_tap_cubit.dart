import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inistagram/core/providers/user_providers.dart';
import 'package:inistagram/features/riles/presentation/pages/riles_page.dart';
import 'package:inistagram/features/user/presentation/pages/profile_page.dart';
import 'package:inistagram/my_app.dart';
import 'package:inistagram/features/posts/screens/add_post.dart';
import 'package:inistagram/features/home/screens/home.dart';
import 'package:inistagram/features/search/screens/search_page.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

part 'home_tap_state.dart';

class HomeTapCubit extends Cubit<HomeTapState> {
  HomeTapCubit() : super(HomeTapInitial());

  static final HomeTapCubit _homeTapCubit =
      BlocProvider.of(navigatorKey.currentContext!);

  static HomeTapCubit get instance => _homeTapCubit;
  final PageController controller = PageController();
  //final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  int currentIndex = 0;

  Color currentColor = Colors.white60;
  Color colorWhenClick = Colors.white;

  List<Widget> pages = [];

  List<Widget> routes(context) {
    var user = Provider.of<UsersProviders>(context).users;
    pages = [
      const HomePage(),
      const SearchPage(),
      const AddPost(),
      if (user != null)
        RilesPage(
          currentUser: user,
        ),
      ProfilePage(
        uid: "${FirebaseAuth.instance.currentUser?.uid}",
      ),
    ];
    return pages;
  }

  void changePage(int index) {
    currentIndex = index;
    emit(SelectPage(pageIndex: index));
  }

  void changePageController(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    emit(SelectPage(pageIndex: index));
  }
}
