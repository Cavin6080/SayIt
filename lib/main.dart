import 'package:sayit/responsive/mobileScreenLayout.dart';
import 'package:sayit/responsive/responsive_layout_screen.dart';
import 'package:sayit/responsive/webScreenLayout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options:const FirebaseOptions(
          apiKey: "AIzaSyBnWEFe2HGi0x3B4vMEIgTFCv2vmXVRJio",
          appId: "1:849238161827:web:f0ed779b8db2bf0b1e0216",
          messagingSenderId: "849238161827",
          projectId: "sayit-6f94d",
          storageBucket: "sayit-6f94d.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buzztalk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponsiveLayout(
        webScreenLayout: WebScreenLayout(),
        mobileScreenLayout: MobileScreenLayout(),
      ),
    );
  }
}
