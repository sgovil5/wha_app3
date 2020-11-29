import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './article_preview.dart';

class ArticleItem extends StatelessWidget {
  final String modality;

  ArticleItem({
    @required this.modality,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('articles')
              .where(modality, isEqualTo: true)
              .snapshots(),
          builder: (context, articleSnapshot) {
            if (articleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final articleData = articleSnapshot.data.documents;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    modality.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  margin: EdgeInsets.all(15),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            if (articleData[index][modality] == true) {
                              return ArticlePreview(
                                articleData[index]['title'],
                                articleData[index]['imageUrl'],
                                articleData[index].documentID,
                              );
                            }
                            return null;
                          },
                          itemCount: articleData.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
