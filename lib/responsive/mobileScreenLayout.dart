import 'package:provider/provider.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/models/usermodel.dart';
import 'package:sayit/providers/user_provider.dart';
import 'package:sayit/screens/login_screen.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
      body: Center(
        child: Text('This is mobile'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        //selectedItemColor: primarycolor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28,
              color: _page == 0 ? primarycolor : secondarycolor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 28,
              color: _page == 1 ? primarycolor : secondarycolor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              size: 28,
              color: _page == 2 ? primarycolor : secondarycolor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 28,
              color: _page == 3 ? primarycolor : secondarycolor,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
