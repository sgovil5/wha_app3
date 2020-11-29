import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/articles/article_pdf_viewer.dart';
import 'screens/practitioners/practitioner_detail_screen.dart';
import 'screens/articles/article_detail_screen.dart';
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
        ArticleDetailScreen.routeName: (ctx) => ArticleDetailScreen(),
        AboutUsSwiper.routeName: (ctx) => AboutUsSwiper(),
        ArticlePDFViewer.routeName: (ctx) => ArticlePDFViewer(),
        PractitionerDetailScreen.routeName: (ctx) => PractitionerDetailScreen(),
      },
    );
  }
}
