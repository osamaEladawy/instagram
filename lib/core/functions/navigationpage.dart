import 'package:flutter/material.dart';

navigationPage(context, page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

navigationReplacePage(context, page) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
}

navigationPageAndRemoveAll(context, page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page), (route) => false);
}

navigationNamePage(BuildContext context, String namePage, [Object? arguments]) {
  Navigator.of(context).pushNamed(namePage, arguments: arguments);
}

navigationNamePageAndRemoveAll(BuildContext context, String namePage,
    {Object? arguments}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
      namePage, arguments: arguments, (route) => false);
}

navigationNameReplacePage(BuildContext context, String page,
    {Object? arguments}) {
  Navigator.of(context).pushReplacementNamed(page, arguments: arguments);
}
