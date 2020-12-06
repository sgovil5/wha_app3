import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/article/article_preview.dart';

class ModalityArticleView extends StatelessWidget {
  static const routeName = '/modality-view';

  @override
  Widget build(BuildContext context) {
    final modality =
        ModalRoute.of(context).settings.arguments.toString().toLowerCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(modality),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('articles')
                .where(modality, isEqualTo: true)
                .snapshots(),
            builder: (ctx, articleSnapshot) {
              if (articleSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final articleData = articleSnapshot.data.documents;
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 70,
                  mainAxisSpacing: 70,
                ),
                itemCount: articleData.length,
                itemBuilder: (ctx, index) {
                  return ArticlePreview(
                    articleData[index]['title'],
                    articleData[index]['imageUrl'],
                    articleData[index].documentID,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
