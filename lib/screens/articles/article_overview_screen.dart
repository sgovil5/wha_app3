import 'package:flutter/material.dart';
import 'package:wha_app3/widgets/article/article_item.dart';

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
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
            ),
            ArticleItem(modality: 'yoga'),
            ArticleItem(modality: 'meditation'),
          ],
        ),
      ),
    );
  }
}
