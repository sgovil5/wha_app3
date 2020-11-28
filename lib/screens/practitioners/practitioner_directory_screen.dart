import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/practitioner/practitioner_preview.dart';

class PractitionerDirectoryScreen extends StatefulWidget {
  @override
  _PractitionerDirectoryScreenState createState() =>
      _PractitionerDirectoryScreenState();
}

class _PractitionerDirectoryScreenState
    extends State<PractitionerDirectoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              child: Text(
                'Directory',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('practitioners')
                      .snapshots(),
                  builder: (ctx, practitionerSnapshot) {
                    if (practitionerSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final practitionerData =
                        practitionerSnapshot.data.documents;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: practitionerData.length,
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {},
                          child: PractitionerPreview(
                            practitionerData[index]['name'],
                            practitionerData[index]['imageUrl'],
                            practitionerData[index]['modalityText'],
                            key: ValueKey(practitionerData[index].documentID),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
