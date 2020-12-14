import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ArticlePDFViewer extends StatefulWidget {
  static const routeName = '/article-pdf';
  @override
  _ArticlePDFViewerState createState() => _ArticlePDFViewerState();
}

class _ArticlePDFViewerState extends State<ArticlePDFViewer> {
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
          appBar: AppBar(title: Text(article['title'])),
          body: Container(
            child: SfPdfViewer.network(article['pdfUrl']),
          ),
        );
      },
    );
  }
}
