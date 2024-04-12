import 'package:flutter/cupertino.dart';
class SharedData{
  double heightIsValid = 50;
  double heightIsNotValid = 70;
  double currentWidth(context){
     double number  = MediaQuery.of(context).size.width;
     return number;
  }


}

