import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wha_app3/widgets/pickers/user_image_picker.dart';

class PractitionerProfileScreen extends StatelessWidget {
  File userImageFile;

  void _pickedImage(File image) {
    userImageFile = image;
  }

  Widget buildSection(BuildContext context, String field, String fieldText,
      String detail, String uid) {
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
                    fieldText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      editForm(context, field, fieldText, uid, detail),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
      await Firestore.instance
          .collection('practitioners')
          .document(uid)
          .updateData({field: submission}).then(
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

  void editForm(BuildContext context, String field, String fieldText,
      String uid, String previousValue) {
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
                    labelText: 'Input your $fieldText',
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
                    trySubmit(isValid, submission, field, uid, context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void tryImageSubmit(BuildContext context, String uid) async {
    if (userImageFile == null) {
      AlertDialog(
        title: Text('You haven\'t selected an image'),
        content: Text('Please select an image'),
        actions: [
          FlatButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      try {
        final imageRef = FirebaseStorage.instance
            .ref()
            .child('practitioners')
            .child('image')
            .child(uid + '.jpeg');
        await imageRef.putFile(userImageFile).onComplete;
        final imageUrl = await imageRef.getDownloadURL();

        await Firestore.instance
            .collection('practitioners')
            .document(uid)
            .updateData({'imageUrl': imageUrl}).then((value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Your image has been submitted'),
                content:
                    Text('Your image will now be displayed in the directory'),
                actions: [
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            barrierDismissible: false,
          );
        });
      } on PlatformException catch (err) {
        var message = 'An Error Occured';
        if (err.message != null) {
          message = err.message;
        }
        AlertDialog(
          title: Text('There was an error'),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final practitionerData = snapshot.data;
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
                    RaisedButton(
                      child: Text('Submit Image'),
                      onPressed: () {
                        tryImageSubmit(context, uid);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildSection(context, "username", "Username",
                        practitionerData["username"], uid),
                    buildSection(context, "description", "Description",
                        practitionerData['description'], uid),
                    buildSection(context, "socialMediaTag", "Social Media Tag",
                        practitionerData['socialMediaTag'], uid),
                    buildSection(context, "websiteUrl", "Website URL",
                        practitionerData['websiteUrl'], uid),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
