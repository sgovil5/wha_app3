import 'package:flutter/material.dart';

class ArticlePreview extends StatelessWidget {
  final Key key;
  final String title;
  final String imageUrl;

  ArticlePreview(this.title, this.imageUrl, {this.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      //selectArticle(context, id), //selectMeal(context, id),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(0),
                ),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 0,
              child: Container(
                width: 150,
                color: Colors.black54,
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
