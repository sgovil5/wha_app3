import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wha_app3/screens/articles/article_submit_form.dart';
import 'package:wha_app3/widgets/article/article_item.dart';

void uploadArticle(BuildContext context) {
  Navigator.of(context)
      .pushNamed(
    ArticleSubmitForm.routeName,
  )
      .then((result) {
    if (result != null) {}
  });
}

class ArticleOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to WHA B-Well"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            ArticleItem(
              modality: 'yoga',
            ),
            ArticleItem(
              modality: 'meditation',
            ),
            ArticleItem(
              modality: 'nutrition',
            ),
            ArticleItem(
              modality: 'acupuncture',
            ),
            ArticleItem(
              modality: 'ayurveda',
            ),
            ArticleItem(
              modality: 'bodyworks',
            ),
            ArticleItem(
              modality: 'other',
            ),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder(
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
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userDocument = userSnapshot.data;
              if (userDocument['isPractitioner']) {
                return FloatingActionButton(
                  onPressed: () {
                    uploadArticle(context);
                  },
                  child: Icon(Icons.add),
                );
              }
              return Container(
                height: 0,
                width: 0,
              );
            },
          );
        },
      ),
    );
  }
}
