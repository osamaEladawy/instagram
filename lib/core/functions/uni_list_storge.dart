
import 'package:image_picker/image_picker.dart';

import 'dart:typed_data';


Future<Uint8List?> pickUpStorage(ImageSource source) async {
  try {
    ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      Uint8List image = await _file.readAsBytes();
      return image;
    }
    print("no image found");
    return null;
  } catch (e) {
    throw Exception(e.toString());
  }
}


pickStorage(ImageSource source)async{
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  print("no image found");
}

// 