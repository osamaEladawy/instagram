import 'package:flutter/material.dart';

navigationPage(page ,context){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>page));
}