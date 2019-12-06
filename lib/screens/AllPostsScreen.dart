import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';

class AllPostsScreen extends StatelessWidget {
  final userService = UserService();
  final FirebaseUser fbuser;

  AllPostsScreen({this.fbuser});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
