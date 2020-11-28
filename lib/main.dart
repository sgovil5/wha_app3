import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/bottom_nav_bar.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/other/about_us_swiper.dart';

void main() {
  runApp(WHAApp());
}

class WHAApp extends StatefulWidget {
  @override
  _WHAAppState createState() => _WHAAppState();
}

class _WHAAppState extends State<WHAApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WHAApp",
      theme: ThemeData(
        primaryColor: const Color(0xffF1FFF9),
        scaffoldBackgroundColor: const Color(0xff222B32),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return BottomNavBar();
          }
          return AuthScreen();
        },
      ),
      initialRoute: '/',
      routes: {
        AboutUsSwiper.routeName: (ctx) => AboutUsSwiper(),
      },
    );
  }
}
