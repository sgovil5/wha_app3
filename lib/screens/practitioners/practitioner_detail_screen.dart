import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                buildSection(
                  context,
                  "Topics",
                  "Here are the topics this practitioner is an expert at",
                  "Check out topics",
                ),
                buildSection(
                  context,
                  "Practitioners",
                  "Here are the practitioners similar to this one",
                  "Check out practitioners",
                ),
                buildSection(
                  context,
                  "Articles",
                  "Here are the articles from this practitioner",
                  "Check out articles",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
