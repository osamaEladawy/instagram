import 'package:flutter/material.dart';
import 'package:inistagram/controller/user_providers.dart';
import 'package:provider/provider.dart';

class ResponsivePage extends StatefulWidget {
  final Widget webScreen;
  final Widget mobileScreen;
  const ResponsivePage({super.key, required this.webScreen, required this.mobileScreen});

  @override
  State<ResponsivePage> createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData()async{
    var users = Provider.of<UsersProviders>(context,listen: false);
    await users.refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder:(context,constrains){
      if(constrains.maxWidth > 600){
        return widget.webScreen;
      }else{
        return widget.mobileScreen;
      }
    });
  }
}