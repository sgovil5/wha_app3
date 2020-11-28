import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wha_app3/widgets/article/article_preview.dart';

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
          stream: Firestore.instance.collection('articles').snapshots(),
          builder: (ctx, articleSnapshot) {
            if (articleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final articleData = articleSnapshot.data.documents;
            var itemLength = 0;
            for (int i = 0; i < articleData.length; i++) {
              if (articleData[i]['title'].contains(query)) itemLength++;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 175,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: itemLength,
              itemBuilder: (ctx, index) {
                if (articleData[index]['title'].contains(query)) {
                  return ArticlePreview(
                    articleData[index]['title'],
                    articleData[index]['imageUrl'],
                    key: ValueKey(articleData[index].documentID),
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
          stream: Firestore.instance.collection('articles').snapshots(),
          builder: (ctx, articleSnapshot) {
            if (articleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final articleData = articleSnapshot.data.documents;
            var itemLength = 0;
            for (int i = 0; i < articleData.length; i++) {
              if (articleData[i]['title'].contains(query)) itemLength++;
            }
            return ListView.builder(
              itemCount: itemLength,
              itemBuilder: (ctx, index) {
                if (articleData[index]['title'].contains(query)) {
                  return ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text(articleData[index]['title']),
                    onTap: () {},
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
