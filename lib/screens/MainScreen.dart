import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/PostService.dart';

import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/";

  FirebaseUser fbUser;

  MainScreen({this.fbUser});
  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("QuenC"),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          postService.initialisePosts();
        },
        child: PostShowingContainer(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final dialog = PostAddingFullScreenDialog();
                return dialog;
              },
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}
