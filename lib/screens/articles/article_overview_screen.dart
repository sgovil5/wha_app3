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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(15, 30, 15, 30),
              child: Text(
                'Welcome to the WHA App',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 22,
                ),
              ),
            ),
            ArticleItem(modality: 'yoga'),
            ArticleItem(modality: 'meditation'),
            ArticleItem(
              modality: 'nutrition',
            ),
            ArticleItem(
              modality: 'naturomedicine',
            )
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
