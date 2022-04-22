import 'package:provider/provider.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/models/usermodel.dart';
import 'package:sayit/providers/user_provider.dart';
import 'package:sayit/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sayit/screens/screens.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _currIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    SearchScreen(),
    FavouritesScreen(),
    ProfileScreen(),
    AddPostScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Users? user = Provider.of<UserProvider>(context).getuser; //added ? to Users
    return Scaffold(
      body: PageView(
        children: [pages[_currIndex]],
      ),
      bottomNavigationBar:_currIndex == 4 ?null: BottomNavBar(),
    );
  }





  NavigationBarTheme BottomNavBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
          indicatorColor: webbackgroundcolor.withOpacity(0.35)),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: Colors.transparent,
        selectedIndex: _currIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            _currIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: primarycolor,
            ),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(
              Icons.search,
              color: primarycolor,
            ),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_outlined),
            selectedIcon: Icon(
              Icons.favorite,
              color: primarycolor,
            ),
            label: "",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: primarycolor,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
