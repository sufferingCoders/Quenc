import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

class MainScreen extends StatefulWidget {
  FirebaseUser fbUser;

  MainScreen({this.fbUser});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isInit = false;
  PostCategory category;
  int pageSize = 50;
  DocumentSnapshot startAfter;
  RetrievedPostsAndLastSnapshot postAndSnapshot;
  PostOrderByOption orderBy = PostOrderByOption.LikeCount;
  List<PostCategory> allCategories;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      // var postService = Provider.of<PostService>(context, listen: false);
      // postService.tryInitPosts();
      isInit = true;
      await loadMore();
      await loadCategories();
    }
    super.didChangeDependencies();
  }

  void orderByUpdater(PostOrderByOption o) {
    setToNull();
    setState(() {
      orderBy = o;
    });
    loadMore();
  }

  Future<void> loadCategories() async {
    var cs = await Provider.of<PostService>(context, listen: false)
        .getAllPostCategories();
    setState(() {
      allCategories = cs;
    });
  }

  void changeCategory(PostCategory cat) async {
    setToNull();
    setState(() {
      category = cat;
    });
    loadMore();
  }

  void refresh() {
    setToNull();
    loadMore();
    loadCategories();
  }

  void setToNull() {
    setState(() {
      isInit = false;
      startAfter = null;
      postAndSnapshot = null;
    });
  }

  Future<void> loadMore() async {
    var newPostAndSnapshot =
        await Provider.of<PostService>(context).getAllPosts(
      categoryId: category?.id,
      pageSize: pageSize,
      orderBy: orderBy,
      startAfter: postAndSnapshot?.lastSnapshot,
    );

    setState(() {
      if (postAndSnapshot == null) {
        postAndSnapshot = newPostAndSnapshot;
        isInit = true;
      } else {
        if (newPostAndSnapshot != null) {
          postAndSnapshot.retrievedPosts
              .addAll(newPostAndSnapshot.retrievedPosts);
          postAndSnapshot.lastSnapshot = newPostAndSnapshot.lastSnapshot;
          isInit = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var postService = Provider.of<PostService>(context);
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(category == null ? "QuenC" : category.categoryName),
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
      drawer: AppDrawer(
        changeCategory: changeCategory,
        allCategories: allCategories,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // postService.initialisePosts();
          refresh();
        },
        child: PostShowingContainer(
          isInit: isInit,
          posts: postAndSnapshot?.retrievedPosts,
          infiniteScrollUpdater: loadMore,
          refresh: refresh,
          orderBy: orderBy,
          orderByUpdater: orderByUpdater,
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
