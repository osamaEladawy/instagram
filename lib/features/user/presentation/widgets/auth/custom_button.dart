import 'package:flutter/material.dart';

class CustomMyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Color? color;

  const CustomMyButton(
      {super.key, this.onPressed, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: MediaQuery.of(context).size.width - 30,
      child: MaterialButton(
        shape:const StadiumBorder(),
        color: color,
        onPressed: onPressed,
        child: Text(title,style:const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
