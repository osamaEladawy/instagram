import 'dart:typed_data';

import 'package:flutter/rendering.dart';

ImageProvider<Object>? profileImage({Uint8List? image, String? imageUrl}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return const AssetImage("assets/images/profile_default.png");
    } else {
      return NetworkImage(imageUrl);
    }
  } else {
    return MemoryImage(image);
  }
}
