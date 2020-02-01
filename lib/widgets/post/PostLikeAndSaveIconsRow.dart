import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/widgets/report/ReportAddingFullScreenDialog.dart';

enum MenuOptions {
  Report,
  Delete,
  BlockUser,
  BlockPost,
}

class PostLikeAndSaveIconsRow extends StatelessWidget {
  PostLikeAndSaveIconsRow({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserGolangService>(
      builder: (context, userService, ch) => Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.favorite),
              color: userService?.user?.likePosts?.contains(post?.id) == true
                  ? Colors.pink
                  : Colors.grey,
              onPressed: () {
                Provider.of<UserGolangService>(context, listen: false)
                    .toggoleFunction(
                  id: post?.id,
                  toggle: ToggleOptions.LikePosts,
                  condition:
                      !(userService?.user?.likePosts?.contains(post?.id) ==
                          true),
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.bookmark),
              color: userService?.user?.savedPosts?.contains(post?.id) == true
                  ? Colors.blue
                  : Colors.grey,
              onPressed: () {
                Provider.of<UserGolangService>(context, listen: false)
                    .toggoleFunction(
                  id: post?.id,
                  toggle: ToggleOptions.SavedPosts,
                );
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              child: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColorDark,
              ),
              // color: userService.user.archivePosts.contains(post.id)
              //     ? Colors.blue
              //     : Colors.grey,
              onTapDown: (detail) async {
                final value = await showMenu(
                  position: RelativeRect.fromLTRB(
                    detail.globalPosition.dx,
                    detail.globalPosition.dy,
                    detail.globalPosition.dx,
                    detail.globalPosition.dy,
                  ),
                  context: context,
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.report),
                        title: const Text(
                          "檢舉",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      value: MenuOptions.Report,
                    ),
                    if (userService.user?.isAdmin ||
                        userService.user?.id == post?.author)
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: const Text(
                            "刪除",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        value: MenuOptions.Delete,
                      ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.block),
                        title: const Text(
                          "屏蔽此文章",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      value: MenuOptions.BlockPost,
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.gavel),
                        title: const Text(
                          "屏蔽此使用者",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      value: MenuOptions.BlockUser,
                    ),
                  ],
                );

                switch (value) {
                  case MenuOptions.Delete:
                    // Show Delete Dialog here
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text("刪除文章"),
                              content: Text("是否刪除文章: \n${post?.title}"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("否"),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                FlatButton(
                                  child: Text("是"),
                                  onPressed: () {
                                    Provider.of<PostGolangService>(context,
                                            listen: false)
                                        .deletePost(post?.id);

                                    var count = 0;
                                    Navigator.popUntil(context, (route) {
                                      return count++ == 2;
                                    });

                                    // Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            ));
                    break;
                  case MenuOptions.Report:
                    // Show Report Dialog here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          final dialog = ReportAddingFullScreenDialog(
                            reportId: post.id,
                            target: ReportTarget.Post,
                          );
                          return dialog;
                        },
                        fullscreenDialog: true,
                      ),
                    );
                    break;

                  case MenuOptions.BlockPost:
                    if (userService.user.id == post.author.id) {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text("錯誤"),
                                content: Text("無法屏蔽自己的文章"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Okay"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text("屏蔽"),
                                content: Text(
                                    "是否屏蔽: \n${post?.title}? 屏蔽後您將無法再看到這篇文章"),
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
                                      Provider.of<UserGolangService>(context,
                                              listen: false)
                                          .toggoleFunction(
                                        id: post?.id,
                                        toggle: ToggleOptions.BlockPost,
                                        condition: true,
                                      );

                                      var count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    },
                                  ),
                                ],
                              ));
                    }

                    break;
                  case MenuOptions.BlockUser:
                    if (userService.user.id == post.author.id) {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text("錯誤"),
                                content: Text("無法屏蔽自己"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Okay"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text("屏蔽"),
                                content:
                                    Text("是否屏蔽此使用者？\n 屏蔽後您將無法看見該使用者的文章以及評論"),
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
                                      Provider.of<UserGolangService>(context,
                                              listen: false)
                                          .toggoleFunction(
                                        id: post?.id,
                                        toggle: ToggleOptions.BlockUser,
                                        condition: true,
                                      );

                                      var count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    },
                                  ),
                                ],
                              ));
                    }
                    break;

                  default:
                    break;
                }

                // Perform Actions
              },
            ),
          )
        ],
      ),
    );
  }
}
