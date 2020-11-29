import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './article_pdf_viewer.dart';

class ArticleDetailScreen extends StatelessWidget {
  static const routeName = '/article-detail';

  void selectPDF(BuildContext context, id) {
    Navigator.of(context)
        .pushNamed(
      ArticlePDFViewer.routeName,
      arguments: id,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleId = ModalRoute.of(context).settings.arguments;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('articles')
          .document(articleId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var article = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(article['title']),
            backgroundColor: const Color(0xff005F75),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text(
                    article['title'],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 26,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    article['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text(
                    'Author: ${article['author']}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 26,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Date Written: 10/19/2020', //${selectedArticle.date.substring(0, 10)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 26,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      selectPDF(context, articleId);
                    },
                    child: Text("Click here to view the article"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
