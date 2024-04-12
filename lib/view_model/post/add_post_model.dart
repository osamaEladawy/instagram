import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../core/class/handle_image.dart';

class AddPostModel { 
  
  TextEditingController description = TextEditingController();
  final myKey = GlobalKey<FormState>();
  bool loading = false;
  bool isPostOrRiles = false;
 
  clearFile(context) {
    var service = Provider.of<HandleImage>(context, listen: false);
    service.file = null;
  }



}
