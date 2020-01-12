import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/screens/ChatScreen.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/chat/ChatRoomShowingList.dart';
import 'package:quenc/widgets/common/AppBottomNavigationBar.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isInit = false;
  PostCategory category;
  int limit = 50;
  OrderByOption orderBy = OrderByOption.LikeCount;
  List<PostCategory> allCategories;
  List<Post> retrievedPosts;
  int currentIdx = 0;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      // var PostGolangService = Provider.of<PostGolangService>(context, listen: false);
      // PostGolangService.tryInitPosts();
      await loadMore();
      isInit = true;
      // await loadCategories();
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

  void idxUpdateFunc(int idx) {
    setState(() {
      currentIdx = idx;
    });
  }

  // Future<void> loadCategories() async {
  //   var cs = await Provider.of<PostGolangService>(context, listen: false)
  //       .getAllPostCategories();
  //   setState(() {
  //     allCategories = cs;
  //   });
  // }

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
    // loadCategories();
  }

  void setToNull() {
    setState(() {
      isInit = false;
      retrievedPosts = null;
    });
  }

  Future<void> loadMore() async {
    var newPostAndSnapshot =
        await Provider.of<PostGolangService>(context).getAllPosts(
      categoryId: category?.id,
      limit: limit,
      orderBy: orderBy,
      skip: retrievedPosts?.length ?? 0,
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

  Widget getMainScrenAppBar(idx) {
    return [
      AppBar(
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
      AppBar(
        // automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("聊天"),
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
    ][idx];
  }

  Widget getMainScreenBody(idx) {
    return [
      RefreshIndicator(
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
      ChatRoomShowingList(),
    ][idx];
  }

  @override
  Widget build(BuildContext context) {
    // var PostGolangService = Provider.of<PostGolangService>(context);
    return Scaffold(
      appBar: getMainScrenAppBar(currentIdx),
      drawer: AppDrawer(
        changeCategory: changeCategory,
      ),
      body: getMainScreenBody(currentIdx),
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
      bottomNavigationBar: AppBottomNavigationBar(
        idx: currentIdx,
        idxUpdateFunc: idxUpdateFunc,
      ),
    );
  }
}
