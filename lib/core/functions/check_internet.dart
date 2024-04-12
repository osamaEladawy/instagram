import 'dart:io';

import 'package:flutter/foundation.dart';

 checkInternet()async{
  try{
    var result = await InternetAddress.lookup("google.com");
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      return true;
    }
  }on SocketException catch(e){
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}