import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/Auth/EmailCheckingNotification.dart';

class EmailVerificationScreen extends StatelessWidget {
  final FirebaseUser fbUser;

  EmailVerificationScreen({this.fbUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("信箱認證"),
        ),
        drawer: AppDrawer(),
        body: EmailCheckingNotification(
          fbUser: fbUser,
        ));
  }
}
