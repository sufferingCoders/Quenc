import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';

class MainScreen extends StatelessWidget {
  final userService = UserService();
  final FirebaseUser fbuser;

  MainScreen({this.fbuser});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
