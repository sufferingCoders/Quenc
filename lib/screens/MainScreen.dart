import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/";

  FirebaseUser fbUser;

  MainScreen({this.fbUser});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      var postService = Provider.of<PostService>(context, listen: false);
      postService.tryInitPosts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("QuenC"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          postService.initialisePosts();
        },
        child: PostShowingContainer(
          posts: postService.posts,
          infiniteScrollUpdater: postService.getPosts,
        ),
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
