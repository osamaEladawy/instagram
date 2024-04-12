import 'dart:io';

import 'package:image_picker/image_picker.dart';

pickStorage(ImageSource source)async{
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  print("no image found");
}

pickStorageImage(ImageSource source)async{
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if(_file != null){
    var fil = File(_file.path);
    return await _file.readAsBytes();
  }
  print("no image found");
}