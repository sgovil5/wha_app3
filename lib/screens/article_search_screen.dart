import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/article/article_preview.dart';
import '../screens/articles/article_detail_screen.dart';

class ArticleSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seach for Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearch(),
              );
            },
          )
        ],
      ),
    );
  }
}

class ArticleSearch extends SearchDelegate<String> {
  void selectArticle(BuildContext context, id) {
    Navigator.of(context)
        .pushNamed(
      ArticleDetailScreen.routeName,
      arguments: id,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
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
              .where(
                'searchKeywords',
                arrayContains: query,
              )
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
                if (articleData[index]['searchKeywords'].contains(query)) {
                  return ArticlePreview(
                    articleData[index]['title'],
                    articleData[index]['imageUrl'],
                    articleData[index].documentID,
                  );
                }
                return null;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
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
              .where(
                'searchKeywords',
                arrayContains: query,
              )
              .snapshots(),
          builder: (ctx, articleSnapshot) {
            if (articleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final articleData = articleSnapshot.data.documents;
            return ListView.builder(
              itemCount: articleData.length,
              itemBuilder: (ctx, index) {
                if (articleData[index]['title'].contains(query)) {
                  return ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text(
                      articleData[index]['title'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      selectArticle(context, articleData[index].documentID);
                    },
                  );
                }
                return null;
              },
            );
          },
        );
      },
    );
  }
}
