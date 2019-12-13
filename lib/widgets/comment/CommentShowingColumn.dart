import 'package:flutter/material.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/widgets/comment/CommentDetailShowingContainer.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';

class CommentShowingColumn extends StatelessWidget {
  const CommentShowingColumn({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommentDetailShowingContainer(
          comment: comment,
        ),
        ContentShowingContainer(
          content: comment.content,
        ),
        const Divider(
          color: Colors.black,
          indent: 10,
          endIndent: 10,
          height: 3,
        ),
      ],
    );
  }
}
