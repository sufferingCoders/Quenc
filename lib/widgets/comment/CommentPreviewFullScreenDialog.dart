import 'package:flutter/material.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/widgets/comment/CommentShowingColumn.dart';

class CommentPreviewFullScreenDialog extends StatelessWidget {
  final Comment comment;

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
          body: SingleChildScrollView(
              child: CommentShowingColumn(
            comment: comment,
          ))

          ),
    );
  }
}
