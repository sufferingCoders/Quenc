import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/screens/ArchivePostsScreen.dart';
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
      body: ListView(
        children: <Widget>[
          Consumer<User>(
            builder: (ctx, user, ch) {
              return ListTile(
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
              );
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
      ),
    );
  }
}
