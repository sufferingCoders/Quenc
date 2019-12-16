import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/screens/ArchivePostsScreen.dart';
import 'package:quenc/screens/CategoryManagemnetScreen.dart';
import 'package:quenc/screens/OwningPostsScreen.dart';
import 'package:quenc/screens/ReportManagementScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile";

  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("個人資訊"),
          centerTitle: true,
        ),
        body: Consumer<User>(
          builder: (ctx, user, ch) {
            return ListView(
              children: <Widget>[
                if (user.isAdmin) ...[
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 60,
                    color: Theme.of(context).primaryColorLight,
                    child: Center(
                      child: Text(
                        "管理員",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.category,
                    ),
                    title: const Text("文章分類管理"),
                    onTap: () {
                      // Need a category management page
                      // push
                      Navigator.pushNamed(
                        context,
                        CategoryManagementScreen.routeName,
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.report,
                    ),
                    title: const Text("舉報案例管理"),
                    onTap: () {
                      // Need a category management page
                      // push
                      Navigator.pushNamed(
                        context,
                        ReportManagementScreen.routeName,
                      );
                    },
                  ),
                  const Divider(),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 60,
                    color: Theme.of(context).primaryColorLight,
                    child: Center(
                      child: Text(
                        "一般使用者",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ],
                ListTile(
                  leading: Icon(
                    Icons.account_box,
                  ),
                  title: const Text("個人檔案"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      UserAttributeSettingScreen.routeName,
                      arguments: user,
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.library_books,
                  ),
                  title: const Text("我的帖子"),
                  onTap: () {
                    Navigator.pushNamed(context, OwingPostsScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.bookmark,
                  ),
                  title: const Text("我的收藏"),
                  onTap: () {
                    Navigator.pushNamed(context, ArchivePostScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.input,
                    textDirection: TextDirection.rtl,
                  ),
                  title: const Text("登出"),
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                    userService.signOut();
                  },
                ),
                const Divider(),
              ],
            );
          },
        ));
  }
}
