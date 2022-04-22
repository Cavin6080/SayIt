import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sayit/Utils/colors.dart';
import 'package:sayit/providers/user_provider.dart';
import 'package:sayit/responsive/mobileScreenLayout.dart';
import 'package:sayit/responsive/responsive_layout_screen.dart';
import 'package:sayit/responsive/webScreenLayout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sayit/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buzztalk',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
     
        home: StreamBuilder(
          //persisting auth state
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                //means user is authnticated
                return const ResponsiveLayout( 
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primarycolor,
              ));
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}




     // home: ResponsiveLayout(
      //   webScreenLayout: WebScreenLayout(),
      //   mobileScreenLayout: MobileScreenLayout(),
      // ),
     