import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostGolangService.dart';

class CategoryManagementScreen extends StatefulWidget {
  static const routeName = "/category-management";

  @override
  _CategoryManagementScreenState createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  bool isInit = false;
  List<PostCategory> categories;
  String searchingStr = "";

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
      categories = null;
    });
    setCategories();
  }

  void setCategories() {
    Provider.of<PostGolangService>(context).getAllPostCategories().then((cat) {
      setState(() {
        categories = cat;
        isInit = true;
      });
    });
  }

  List<PostCategory> get showingCategories {
    if (categories == null || categories.isEmpty) {
      return [];
    }

    return categories
        .where((c) => c?.categoryName?.contains(searchingStr) ?? false)
        .toList();
  }

  Widget mainBody() {
    return categories == null || categories.isEmpty
        ? isInit
            ? Center(
                child: Text("未有分類"),
              )
            : Center(
                child: CircularProgressIndicator(),
              )
        : Builder(
            builder: (context) {
              var show = showingCategories;

              return ListView.separated(
                separatorBuilder: (ctx, idx) {
                  return const Divider();
                },
                itemCount: show.length,
                itemBuilder: (content, idx) {
                  return ListTile(
                    title: Text(show[idx].categoryName),
                    onTap: () {
                      // 以後可以顯示Category資料在這
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () {
                        //Deleteing Category here

                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text("刪除分類"),
                                  content: Text(
                                      "是否要刪除分類: ${show[idx].categoryName} ?"),
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
                                        Provider.of<PostGolangService>(context,
                                                listen: false)
                                            .deletePostCategoriesById(
                                                show[idx].id)
                                            .then((v) {
                                          refresh();
                                        });
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ));

                        Provider.of<PostGolangService>(context, listen: false)
                            .deletePostCategoriesById(show[idx].id);
                      },
                    ),
                  );
                },
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: TextField(
          onChanged: (v) {
            setState(() {
              searchingStr = v;
            });
          },
          decoration: const InputDecoration(
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: "搜尋...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            // border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              // Show Dialog first

              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text("加入分類"),
                        content: Text("是否要加入分類: $searchingStr ?"),
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
                              Provider.of<PostGolangService>(context,
                                      listen: false)
                                  .addPostCategory(PostCategory(
                                categoryName: searchingStr,
                              ))
                                  .then((v) {
                                refresh();
                              });
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: mainBody(),
      ),
    );
  }
}
