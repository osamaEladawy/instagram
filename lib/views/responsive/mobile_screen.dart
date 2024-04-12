
import 'package:flutter/material.dart';
import 'package:inistagram/core/functions/notification.dart';
import 'package:inistagram/view_model/responsive/mobile_viewmodel.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  MobileViewModel viewModel = MobileViewModel();
  var service = MyNotification();




  @override
  void initState() {
    super.initState();
    viewModel.controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        fixedColor: Colors.white70,
        currentIndex: viewModel.currentIndex,
        onTap: (page) {
          viewModel.onChangePage(page);
          setState(() {});
        },
       items : [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: viewModel.currentIndex == 0
                    ? viewModel.colorWhenClick
                    : viewModel.currentColor,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: viewModel.currentIndex == 1
                    ? viewModel.colorWhenClick
                    : viewModel.currentColor,
              ),
              label: "search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: viewModel.currentIndex == 2
                    ? viewModel.colorWhenClick
                    : viewModel.currentColor,
              ),
              label: "post"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection,
                color: viewModel.currentIndex == 3
                    ? viewModel.colorWhenClick
                    : viewModel.currentColor,
              ),
              label: "Riles"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: viewModel.currentIndex == 4
                    ? viewModel.colorWhenClick
                    : viewModel.currentColor,
              ),
              label: "profile"),
        ],
      ),

      body: PageView(
        controller: viewModel.controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          viewModel.changeState(page);
          setState(() {});
        },
        children: [
          ...List.generate(viewModel.page(context).length, (index) {
            return viewModel.pages[index];
          })
        ],
      ),
      //viewModel.pages[viewModel.currentIndex]
    );
  }
}
