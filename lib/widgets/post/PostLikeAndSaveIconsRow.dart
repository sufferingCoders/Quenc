import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/widgets/report/ReportAddingFullScreenDialog.dart';

enum MenuOptions {
  Report,
  Delete,
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
