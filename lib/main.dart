import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/articles/article_submit_form.dart';
import 'screens/articles/article_pdf_viewer.dart';
import 'screens/practitioners/practitioner_detail_screen.dart';
import 'screens/articles/article_detail_screen.dart';
import 'screens/bottom_nav_bar.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/other/about_us_swiper.dart';
import 'screens/modality_article_view.dart';

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
            return FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final uid = futureSnapshot.data.uid;
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return BottomNavBar(snapshot.data['isPractitioner']);
                  },
                );
              },
            );
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
        ModalityArticleView.routeName: (ctx) => ModalityArticleView(),
        ArticleSubmitForm.routeName: (ctx) => ArticleSubmitForm(),
      },
    );
  }
}
