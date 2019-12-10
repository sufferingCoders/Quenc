import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as mk;
import 'package:quenc/models/Post.dart';

class PostPreviewFullScreenDialog extends StatelessWidget {
  final Post post;

  // RegExp reg = RegExp(r"/!\[.*?\]\((.*?)\)/");
  final RegExp imageReg = RegExp(r"!\[.*?\]\(.*?\)");

  PostPreviewFullScreenDialog({this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("預覽"),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoixIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("預覽"),
              floating: true,
              // pinned: true,
              snap: true,
              // primary: true,
              // forceElevated: innerBoxIsScrolled,
              centerTitle: true,
              // bottom: TabBar(
              //   tabs: <Widget>[
              //     Tab(
              //       text: "編輯",
              //     ),
              //     Tab(
              //       text: "預覽",
              //     ),
              //   ],
              // ),
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
                  color:
                      post.authorGender == "male" ? Colors.blue : Colors.pink,
                  size: 35,
                ),
                // isThreeLine: true,
                title: Text(
                  "${post.authorName}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                // subtitle: Text("${post.authorName}"),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
              child: Text(
                "${post.title}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
              child: Text(
                "${DateFormat("h:mm a   dd, MMM, yyyy").format(post.createdAt)}",
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
                  // var match = imageReg.firstMatch(post.content);
                  // String firstImageUrl =
                  //     post.content.substring(match.start, match.end);
                  // print(firstImageUrl);
                  // int idxStart = firstImageUrl.indexOf("(");
                  // var retrievedURL = firstImageUrl.substring(idxStart+1, firstImageUrl.length-1);
                  var mdText = mk.markdownToHtml(
                    post.content.replaceAll("\n", "</br>"),
                    extensionSet: mk.ExtensionSet.gitHubWeb,
                  );

                  // return Html(
                  //   useRichText: true,
                  //   data: mdText,
                  // );
                  // );
                  return HtmlWidget(
                    mdText,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
