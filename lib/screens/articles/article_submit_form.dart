import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class ArticleSubmitForm extends StatefulWidget {
  static const routeName = '/article-submit';
  @override
  _ArticleSubmitFormState createState() => _ArticleSubmitFormState();
}

class _ArticleSubmitFormState extends State<ArticleSubmitForm> {
  String title;
  String author;
  String description;
  String imageUrl;
  bool meditation = false;
  bool yoga = false;
  File pdf;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> setSearchParam(String inputTitle) {
    List<String> searchList = List();
    String temp = "";
    for (int i = 0; i < inputTitle.length; i++) {
      temp = temp + inputTitle[i];
      searchList.add(temp);
    }
    return searchList;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('article_pdf')
            .child(title + '-' + author + '.pdf');
        await ref.putFile(pdf).onComplete;
        final pdfUrl = await ref.getDownloadURL();
        await Firestore.instance
            .collection('articles')
            .document(title + '-' + author)
            .setData({
          'author': author.trim(),
          'imageUrl': imageUrl.trim(),
          'meditation': meditation,
          'pdfUrl': pdfUrl,
          'searchKeywords': setSearchParam(title),
          'title': title.trim(),
          'yoga': yoga,
        });
      } on PlatformException catch (err) {
        var message = 'An Error Occured, please check your credentials';
        if (err.message != null) {
          message = err.message;
        }
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } catch (err) {
        print(err);
      }
    }
  }

  void _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      final pickedPdfFile = File(file.path);
      setState(() {
        pdf = pickedPdfFile;
      });
    }
  }

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter the Title',
        focusColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your title cannot be empty';
        } else if (value.length <= 5) {
          return 'Your title must be longer than 5 characters';
        }
        return null;
      },
      onSaved: (String value) {
        title = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter a Short Description',
        focusColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your description cannot be empty';
        } else if (value.length < 50 || value.length > 150) {
          return 'Your desciption must be between 50 to 150 characters';
        }
        return null;
      },
      onSaved: (String value) {
        description = value;
      },
    );
  }

  Widget _buildAuthor() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter the Author\'s name',
        focusColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'This field cannot be empty';
        } else if (value.length < 2) {
          return 'The name of the author must be more than 2 characters';
        }
        return null;
      },
      onSaved: (String value) {
        author = value;
      },
    );
  }

  Widget _buildImageUrl() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Enter a valid Image URL',
        focusColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "Your image URL cannot be empty";
        } else if (!(value.contains('.jpg') || value.contains('.png'))) {
          return "This is not a valid image";
        }
        return null;
      },
      onSaved: (String value) {
        imageUrl = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload an Article"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(),
                _buildDescription(),
                _buildAuthor(),
                _buildImageUrl(),
                Container(
                  child: Text(
                    "Toggle the modalities",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                SwitchListTile(
                  title: const Text(
                    'Yoga',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: yoga,
                  onChanged: (value) {
                    setState(() {
                      yoga = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Meditation',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: meditation,
                  onChanged: (value) {
                    setState(() {
                      meditation = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    _pickFile();
                  },
                  child: Text(
                    'Upload a PDF for your article',
                    //style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text("Submit Article"),
                  onPressed: _trySubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
