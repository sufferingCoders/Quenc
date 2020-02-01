import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/chat/RandomChatRoom.dart';
import 'package:quenc/widgets/common/AppBottomNavigationBar.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';
import 'package:quenc/widgets/report/ReportAddingFullScreenDialog.dart';

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

  TextEditingController sendingController = TextEditingController();

  List<Widget> mainScreenBody;
  List<Widget> mainScreenAppBar;
  List<Widget> floatActionButton;
  List<Widget> bottomNavigationBar;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    if (!isInit) {
      initFunction();
    }

    super.didChangeDependencies();
  }

  void initFunction() async {
    User currentUser = Provider.of<UserGolangService>(context).user;

    await loadMore();
    isInit = true;

    List<Post> filteredPost = retrievedPosts.where((p) =>
        !(currentUser.blockedPosts.contains(p.id) ||
            currentUser.blockedUsers.contains(p.author.id))).toList();

    mainScreenBody = [
      RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: PostShowingContainer(
          isInit: isInit,
          posts: filteredPost,
          infiniteScrollUpdater: loadMore,
          refresh: refresh,
          orderBy: orderBy,
          orderByUpdater: orderByUpdater,
        ),
      ),
      RandomChatRoom(), // changing this to random chat
    ];

    mainScreenAppBar = [
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
        centerTitle: true,
        title: Text("半日聊天"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              ChatRoom random =
                  Provider.of<UserGolangService>(context).randomChatRoom;
              if (random.id == null) {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text("錯誤"),
                        content: Text("未能找到相對應的聊天"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("確認"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    });
              }

              // jump to report page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final dialog = ReportAddingFullScreenDialog(
                      reportId: random.id,
                      target: ReportTarget.Chat,
                    );
                    return dialog;
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            icon: Icon(Icons.report),
          ),
          IconButton(
            onPressed: () {
              // Show alert dialog

              ChatRoom random =
                  Provider.of<UserGolangService>(context).randomChatRoom;

              showDialog(
                  context: context,
                  builder: (ctx) {
                    Duration timePass =
                        DateTime.now().difference(random.createdAt);

                    return AlertDialog(
                      title: Text("離開聊天"),
                      content: Text(
                          "是否離開此聊天室?\n(必須連接12小時以上才可離開)\n目前連線時間為:\n${timePass.inHours}小時: ${timePass.inMinutes % 60}分"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("否"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text("是"),
                          onPressed: () {
                            if (DateTime.now()
                                    .difference(random.createdAt)
                                    .compareTo(Duration(days: 1)) >
                                0) {
                              Provider.of<UserGolangService>(context,
                                      listen: false)
                                  .leaveRandomChatRoom();
                              Navigator.of(context).pop(true);
                            } else {
                              Navigator.of(context).pop(true);
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text("未能離開"),
                                      content: Text(
                                          "未超過12小時, 未能關閉此聊天室, 若您需要協助可使用舉報系統"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("確認"),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.input,
              textDirection: TextDirection.rtl,
              size: 30,
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => idxUpdateFunc(0),
        ),
      ),
    ];

    floatActionButton = [
      FloatingActionButton(
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
      Container(),
    ];

    bottomNavigationBar = [
      AppBottomNavigationBar(
        idx: currentIdx,
        idxUpdateFunc: idxUpdateFunc,
      ),
      ChatBottomNavigationBar(sendingController: sendingController),
    ];
  }

  void orderByUpdater(OrderByOption o) {
    setToNull();
    setState(() {
      orderBy = o;
    });
    initFunction();
  }

  void idxUpdateFunc(int idx) {
    setState(() {
      currentIdx = idx;
    });
  }

  void changeCategory(PostCategory cat) async {
    setToNull();
    setState(() {
      category = cat;
    });
    initFunction();
  }

  void refresh() {
    setToNull();
    initFunction();
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

    if (retrievedPosts == null) {
      setState(() {
        retrievedPosts = newPostAndSnapshot;
        isInit = true;
      });
    } else {
      if (newPostAndSnapshot != null) {
        setState(() {
          retrievedPosts.addAll(newPostAndSnapshot);
          isInit = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainScreenAppBar == null
          ? AppBar(
              title: Text("QuenC"),
              centerTitle: true,
            )
          : mainScreenAppBar[currentIdx],
      drawer: AppDrawer(
        changeCategory: changeCategory,
      ),
      body: mainScreenBody == null ? Container() : mainScreenBody[currentIdx],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: floatActionButton == null
          ? FloatingActionButton(
              onPressed: () {},
            )
          : floatActionButton[currentIdx],
      bottomNavigationBar: bottomNavigationBar == null
          ? Container()
          : bottomNavigationBar[currentIdx],
    );
  }
}

class ChatBottomNavigationBar extends StatelessWidget {
  const ChatBottomNavigationBar({
    Key key,
    @required this.sendingController,
  }) : super(key: key);

  final TextEditingController sendingController;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        child: Row(
          // or using wrap
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 8, top: 8, bottom: 8),
                child: TextField(
                  controller: sendingController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    // labelText: "標題",
                    // border: InputBorder.none,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 13),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.send),
                onPressed: () {
                  if (sendingController.text != null &&
                      sendingController.text.isNotEmpty)
                    Provider.of<UserGolangService>(context)
                        .addMessageToRandomChatRoom(
                      Message(
                        content: sendingController.text,
                        messageType: 1,
                      ),
                    );
                  sendingController.text = "";
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
