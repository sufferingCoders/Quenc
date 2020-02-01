import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';
import 'package:quenc/widgets/post/PostDetailShowingColumn.dart';
import 'package:quenc/widgets/post/ScrollHideSliverAppBar.dart';

class PostPreviewFullScreenDialog extends StatelessWidget {
  final Post post;

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
            ScrollHideSliverAppBar(
              titleText: "預覽",
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            PostDetailShowingColumn(post: post),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02),
              child: ContentShowingContainer(content: post.content),
            ),
          ],
        ),
      ),
    );
  }
}
