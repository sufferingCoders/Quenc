import 'package:flutter/material.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/widgets/comment/CommentShowingColumn.dart';

class CommentShowingFutureBuilder extends StatelessWidget {
  final Post post;
  final Future future;
  final userService = UserService();
  CommentShowingFutureBuilder(
    this.future, {
    this.post,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: Text("載入評論中"),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: Text("評論載入錯誤"),
              ),
            ),
          );
        }

        if (snapshot.data == null || snapshot.data?.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: Text("未有評論"),
              ),
            ),
          );
        }

        List<Widget> allComments = [];
        List<Comment> retrievedComments = snapshot.data;
        for (var c in retrievedComments) {
          allComments.add(Container(
            child: CommentShowingColumn(comment: c, post: post),
          ));
        }

        return Column(
          children: <Widget>[
            ...allComments,
          ],
        );
      },
    );
  }
}
