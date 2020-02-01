import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/comment/CommentDetailShowingContainer.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';
import 'package:quenc/widgets/post/PostLikeAndSaveIconsRow.dart';
import 'package:quenc/widgets/report/ReportAddingFullScreenDialog.dart';

class CommentShowingColumn extends StatelessWidget {
  const CommentShowingColumn({
    Key key,
    @required this.comment,
    this.post,
  }) : super(key: key);

  final Post post;
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (detail) async {
        User user = Provider.of<UserGolangService>(context).user;
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
            if (user.isAdmin)
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
                      title: Text("刪除評論"),
                      content: Text(
                          "是否刪除 ${Utils.getDisplayNameFromDomain(comment.authorDomain)} 的回文"),
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
                            Provider.of<CommentGolangService>(context,
                                    listen: false)
                                .deleteComment(comment.id);

                            Navigator.of(context).pop(true);
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
                    reportId: comment.id,
                    target: ReportTarget.Comment,
                  );
                  return dialog;
                },
                fullscreenDialog: true,
              ),
            );

            break;

          case MenuOptions.BlockUser:
            if (user.id == post.author.id) {
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
                        content: Text("是否屏蔽此使用者？\n 屏蔽後您將無法看見該使用者的文章以及評論"),
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
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CommentDetailShowingContainer(
            post: post,
            comment: comment,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: ContentShowingContainer(
              content: comment.content,
            ),
          ),
          const Divider(
            color: Colors.black,
            indent: 10,
            endIndent: 10,
            height: 3,
          ),
        ],
      ),
    );
  }
}
