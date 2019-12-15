import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text("QuenC"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("搜尋"),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                color: theme.primaryColorLight,
                child: Center(
                  child: Text(
                    "類別",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            // ListTile(
            //     leading: const Icon(
            //       Icons.input,
            //       textDirection: TextDirection.rtl,
            //     ),
            //     title: const Text("登出"),
            //     onTap: () {
            //       // Navigator.of(context)
            //       //     .pushReplacementNamed(MainScreen.routeName);
            //       Navigator.popUntil(context, ModalRoute.withName("/"));
            //       UserService().signOut();
            //     }),
            // const Divider(),
          ],
        ),
      ),
    );
  }
}
