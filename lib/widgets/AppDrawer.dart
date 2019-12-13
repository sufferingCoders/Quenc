import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text("QuenC"),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.input,
                  textDirection: TextDirection.rtl,
                ),
                title: const Text("登出"),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(MainScreen.routeName);
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                  UserService().signOut();
                }),
          ],
        ),
      ),
    );
  }
}
