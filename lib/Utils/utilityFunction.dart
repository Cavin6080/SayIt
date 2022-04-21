import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sayit/Utils/colors.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image Selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
      backgroundColor: primarycolor,
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
    ),
  );
}
