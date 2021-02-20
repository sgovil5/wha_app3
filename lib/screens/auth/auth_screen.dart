import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<bool> practitionerCheck(String email) async {
    final list =
        await Firestore.instance.collection('list').document('list').get();
    final practitionerList = list['list'].map((e) => e.toLowerCase()).toList();
    print(practitionerList);
    if (practitionerList.contains(email.toLowerCase()))
      return true;
    else
      return false;
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        practitionerCheck(email).then((value) async {
          await Firestore.instance
              .collection('users')
              .document(authResult.user.uid)
              .setData({
            'username': username,
            'email': email.toLowerCase(),
            'isPractitioner': value,
          });
          if (value) {
            await Firestore.instance
                .collection('practitioners')
                .document(authResult.user.uid)
                .setData({
              'email': email.toLowerCase(),
              'username': username,
              'imageUrl': "",
              'websiteUrl': "",
              'description': "",
              'socialMediaTag': "",
            });
          }
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
