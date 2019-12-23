import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
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
  int limit = 50;
  int skip;
  OrderByOption orderBy = OrderByOption.LikeCount;
  List<PostCategory> allCategories;
  List<Post> retrievedPosts;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      // var PostGolangService = Provider.of<PostGolangService>(context, listen: false);
      // PostGolangService.tryInitPosts();
      isInit = true;
      await loadMore();
      await loadCategories();
    }
    super.didChangeDependencies();
  }

  void orderByUpdater(OrderByOption o) {
    setToNull();
    setState(() {
      orderBy = o;
    });
    loadMore();
  }

  Future<void> loadCategories() async {
    var cs = await Provider.of<PostGolangService>(context, listen: false)
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
      skip = 0;
    });
  }

  Future<void> loadMore() async {
    var newPostAndSnapshot =
        await Provider.of<PostGolangService>(context).getAllPosts(
      categoryId: category?.id,
      limit: limit,
      orderBy: orderBy,
      skip: skip,
    );

    setState(() {
      if (retrievedPosts == null) {
        retrievedPosts = newPostAndSnapshot;
        isInit = true;
      } else {
        if (newPostAndSnapshot != null) {
          retrievedPosts.addAll(newPostAndSnapshot);
          isInit = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var PostGolangService = Provider.of<PostGolangService>(context);
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
          // PostGolangService.initialisePosts();
          refresh();
        },
        child: PostShowingContainer(
          isInit: isInit,
          posts: retrievedPosts,
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
