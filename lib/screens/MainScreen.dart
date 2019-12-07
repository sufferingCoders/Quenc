import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/widgets/AppDrawer.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/";
  final userService = UserService();
  final FirebaseUser fbUser;

  MainScreen({this.fbUser});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuenC"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("All Posts Here"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          
        },
      ),
    );
  }
}
