import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/article/article_preview.dart';

class PractitionerDetailScreen extends StatelessWidget {
  static const routeName = '/practitioner-detail';

  Widget buildSection(
      BuildContext context, String title, String body, String action) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
      height: 180,
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.green,
        elevation: 3,
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  textScaleFactor: 2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  action,
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final practitionerId = ModalRoute.of(context).settings.arguments;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('practitioners')
          .document(practitionerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var practitioner = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              practitioner['name'],
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(practitioner['imageUrl']),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: double.infinity,
                  child: Text(
                    practitioner['name'],
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Website: " + practitioner['websiteUrl'],
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Social Media: " + practitioner['socialMediaTag'],
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Email: " + practitioner['email'],
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "All the articles of the practitioner",
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (ctx, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('articles')
                            .where('author', isEqualTo: practitioner['name'])
                            .snapshots(),
                        builder: (ctx, articleSnapshot) {
                          if (articleSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final articleData = articleSnapshot.data.documents;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      return ArticlePreview(
                                        articleData[index]['title'],
                                        articleData[index]['imageUrl'],
                                        articleData[index].documentID,
                                      );
                                    },
                                    itemCount: articleData.length,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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
