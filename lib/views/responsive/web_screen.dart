import 'package:flutter/material.dart';
import 'package:inistagram/view_model/responsive/web_viewmodel.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  WebViewModel viewModel = WebViewModel();

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
      appBar: AppBar(
        title: const Text("Web Screen"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              viewModel.onChangePage(0);
              setState(() {});
            },
            icon: Icon(
              Icons.home,
              color: viewModel.currentIndex == 0
                  ? viewModel.colorWhenClick
                  : viewModel.currentColor,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.onChangePage(1);
              setState(() {});
            },
            icon: Icon(
              Icons.search,
              color: viewModel.currentIndex == 1
                  ? viewModel.colorWhenClick
                  : viewModel.currentColor,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.onChangePage(2);
              setState(() {});
            },
            icon: Icon(
              Icons.add_a_photo,
              color: viewModel.currentIndex == 2
                  ? viewModel.colorWhenClick
                  : viewModel.currentColor,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.onChangePage(3);
              setState(() {});
            },
            icon: Icon(
              Icons.favorite,
              color: viewModel.currentIndex == 3
                  ? viewModel.colorWhenClick
                  : viewModel.currentColor,
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.onChangePage(4);
              setState(() {});
            },
            icon: Icon(
              Icons.person,
              color: viewModel.currentIndex == 4
                  ? viewModel.colorWhenClick
                  : viewModel.currentColor,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: viewModel.controller,
        onPageChanged: (page) {
          viewModel.changeState(page);
          setState(() {});
        },
        children: viewModel.page(context),
      ),
    );
  }
}
