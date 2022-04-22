import 'dart:ffi';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/Utils/utilityFunction.dart';
import 'package:sayit/resources/auth_methods.dart';
import 'package:sayit/responsive/mobileScreenLayout.dart';
import 'package:sayit/responsive/responsive_layout_screen.dart';
import 'package:sayit/responsive/webScreenLayout.dart';
import 'package:sayit/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading =
      false; //signup takes time,so to show a loading indicator till then

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  //image picking
  void selectImage() async {
    try {
      Uint8List image = await pickImage(ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      String error = e.toString();
    }
  }

  //signup user function for signup button
  void signUpUser() async {
    setState(() {
      _isLoading = true; //because we are not signed up yet
    });
    String result = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false; //because we have signed up
    });

    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>const  ResponsiveLayout( 
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopImages(),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color.fromRGBO(49, 39, 79, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Stack(
                    children: [
                      Center(
                        child: _image != null
                            ? CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                              ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 150,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: primarycolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  UsernamePassField(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    emailcontroller: _emailController,
                    biocontroller: _bioController,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primarycolor,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'Already have an account\?  ',
                            style: TextStyle(
                              color: deeppurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: deeppurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UsernamePassField extends StatelessWidget {
  const UsernamePassField({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.biocontroller,
    required this.emailcontroller,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController biocontroller;
  final TextEditingController emailcontroller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(196, 135, 198, .3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: usernameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Username',
                hintStyle: TextStyle(color: secondarycolor),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: biocontroller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Bio',
                hintStyle: TextStyle(color: secondarycolor),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'E-mail',
                hintStyle: TextStyle(color: secondarycolor),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
                hintStyle: TextStyle(color: secondarycolor),
                focusedBorder: InputBorder.none,
              ),
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }
}

class TopImages extends StatelessWidget {
  const TopImages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: -20,
            height: 200,
            width: size.width,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            height: 200,
            width: size.width + 20,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background-2.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
