import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wha_app3/widgets/pickers/user_image_picker.dart';

class PractitionerProfileScreen extends StatelessWidget {
  File userImageFile;

  void _pickedImage(File image) {
    userImageFile = image;
  }

  Widget buildSection(
      BuildContext context, String field, String detail, String uid) {
    return Column(
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          height: 0,
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    field,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => editForm(context, field, uid, detail),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                detail,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void trySubmit(
    bool isValid,
    String submission,
    String field,
    String uid,
    BuildContext context,
  ) async {
    try {
      var res = await Firestore.instance
          .collection('practitioners')
          .document(uid)
          .get();
      if (res.exists) {
        try {
          await Firestore.instance
              .collection('practitioners')
              .document(uid)
              .updateData({field: submission, uid: uid}).then(
            (value) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Your edits have been processed"),
                    actions: [
                      FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        } on PlatformException catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('There was an error'),
                content: Text(e.message),
                actions: [
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      } else {
        try {
          await Firestore.instance
              .collection('practitioners')
              .document(uid)
              .setData({field: submission}).then(
            (value) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Your edits have been processed"),
                    actions: [
                      FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        } on PlatformException catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('There was an error'),
                content: Text(e.message),
                actions: [
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('There was an error'),
            content: Text(e.message),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  void editForm(
      BuildContext context, String field, String uid, String previousValue) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String submission = previousValue;
    bool isValid = false;
    showBottomSheet(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Input your $field',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (String value) {
                    if (value.isEmpty)
                      return 'Description can\'t be empty';
                    else if (value.length > 50)
                      return 'Description must be less than 50 characters';
                    return null;
                  },
                  onSaved: (String value) {
                    submission = value;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  isValid = _formKey.currentState.validate();
                  FocusScope.of(context).unfocus();
                  if (isValid) {
                    _formKey.currentState.save();
                  }
                  trySubmit(isValid, submission, field, uid, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Profile'),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final uid = futureSnapshot.data.uid;
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('practitioners')
                  .document(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Image
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Upload your profile picture',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: UserImagePicker(_pickedImage),
                      ),
                      buildSection(context, "name", "jack", uid)
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
