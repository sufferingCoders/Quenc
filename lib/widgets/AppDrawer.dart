import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostGolangService.dart';

class AppDrawer extends StatefulWidget {
  final Function changeCategory;

  AppDrawer({
    this.changeCategory,
  });

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isInit = false;
  List<PostCategory> allCategories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      setCategories();
    }
  }

  void refresh() {
    setState(() {
      isInit = false;
      allCategories = null;
    });
    setCategories();
  }

  void setCategories() {
    Provider.of<PostGolangService>(context).getAllPostCategories().then((cat) {
      setState(() {
        allCategories = cat;
        isInit = true;
      });
    });
  }

  List<Widget> allCategoriesListTile(BuildContext ctx) {
    List<Widget> listTiles = [];

    listTiles.add(ListTile(
      leading: Icon(Icons.label),
      title: Text("所有"),
      onTap: () {
        widget.changeCategory(null);
        Navigator.of(ctx).pop();
      },
    ));
    listTiles.add(const Divider());

    if (allCategories == null) {
      if (!isInit) {
        listTiles.add(ListTile(
          leading: FittedBox(
            child: CircularProgressIndicator(),
          ),
          title: Text("分類載入中..."),
        ));
      }

      return listTiles;
    }

    for (var c in allCategories) {
      listTiles.add(ListTile(
        leading: Icon(Icons.label),
        title: Text(c.categoryName),
        onTap: () {
          widget.changeCategory(c);
          Navigator.of(ctx).pop();
        },
      ));
      listTiles.add(const Divider());
    }

    return listTiles;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                title: Text("QuenC"),
                automaticallyImplyLeading: false,
              ),
              // ListTile(
              //   leading: Icon(Icons.search),
              //   title: Text("搜尋"),
              // ), // need to add the corresponded api in the backend for searching
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
              ...allCategoriesListTile(context),
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
      ),
    );
  }
}
