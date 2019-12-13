import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/comment/CommentAddingFullScreenDialog.dart';

class WritingCommentFloatButton extends StatelessWidget {
  const WritingCommentFloatButton({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Wrap(
        children: <Widget>[
          Icon(Icons.account_circle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("我要回帖"),
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CommentAddingFullScreenDialog(
                belongPost: post.id,
              );
            },
            fullscreenDialog: true,
          ),
        );
        // Need a full Screen Dialog for replying
      },
    );
  }
}
