import 'package:chat_app_demo/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/database/firebase_handler.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(Map userData, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: userData['email'],
          password: userData['password'],
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: userData['email'],
          password: userData['password'],
        );

        await FirebaseHandler().createUser(authResult, userData);
      }
      // final ref = FirebaseStorage.instance
      //     .ref()
      //     .child('user_image')
      //     .child(authResult.user?.uid ?? '' '.jpg');

      // await ref.putFile(imageFile);
      // final url = await ref.getDownloadURL();

    } catch (e) {
      var message = 'An error occured, please check your credentials';

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
