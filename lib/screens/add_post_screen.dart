import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/Utils/utilityFunction.dart';
import 'package:sayit/models/usermodel.dart';
import 'package:sayit/providers/user_provider.dart';
import 'package:sayit/resources/firestore_methods.dart';
import 'package:sayit/responsive/mobileScreenLayout.dart';
import 'package:sayit/screens/home_screen.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key, this.file}) : super(key: key);
  Uint8List? file;

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _file = widget.file;
    final Users? user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Post to',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(color: purplecolor, fontSize: 20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: purplecolor,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MobileScreenLayout(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => postImg(user!.uid, user.username, user.photoUrl),
            child: Text(
              'Post',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: purplecolor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading ? const LinearProgressIndicator() : Container(),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.photoUrl,
                      ),
                      radius: 35),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: AspectRatio(
                aspectRatio: 2 / 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: primarycolor.withOpacity(0.3),
                          offset: const Offset(0, 10),
                          blurRadius: 10)
                    ],
                    image: DecorationImage(
                      image: MemoryImage(_file!),
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void postImg(
    String uid,
    String username,
    String profileImg,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String result = await FireStoreMethods().uploadPost(
          _textEditingController.text, _file!, uid, username, profileImg);
      if (result == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted Successfully', context);
        clearImg();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MobileScreenLayout()));
      } else {
        showSnackBar(result, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImg() {
    setState(() {
      _file = null;
    });
  }
}
