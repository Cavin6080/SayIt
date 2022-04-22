import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/Utils/utilityFunction.dart';
import 'package:sayit/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _file;

  @override
  Widget build(BuildContext context) {
    return _file != null
        ? AddPostScreen(
            file: _file,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Home',
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        color: purplecolor,
                        fontSize: 27,
                        fontWeight: FontWeight.w600)),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      return _selectImage(context);
                    },
                    icon: const Icon(
                      Icons.add_box_rounded,
                      color: purplecolor,
                    ))
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
            ),
          );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }
}
