import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as mk;
import 'package:quenc/models/Comment.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentPreviewFullScreenDialog extends StatelessWidget {
  final Comment comment;
  final RegExp imageReg = RegExp(r"!\[.*?\]\(.*?\)");

  CommentPreviewFullScreenDialog({this.comment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("預覽回文"),
              floating: true,
              snap: true,
              centerTitle: true,
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: comment.authorGender == "male"
                      ? Colors.blue
                      : Colors.pink,
                  size: 35,
                ),
                // isThreeLine: true,
                title: Text(
                  "${comment.authorName}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
              child: Text(
                "${DateFormat("h:mm a   dd, MMM, yyyy").format(comment.createdAt)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
              child: Builder(
                builder: (context) {
                  var mdText = mk.markdownToHtml(
                    comment.content.replaceAll("\n", "</br>"),
                    extensionSet: mk.ExtensionSet.gitHubWeb,
                  );

                  return HtmlWidget(
                    mdText,
                    onTapUrl: (url) async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ClipboardManager.copyToClipBoard(url).then(
                          (r) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("無法顯示此網址, 但已將此網址複製至剪貼簿"),
                                duration: Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
