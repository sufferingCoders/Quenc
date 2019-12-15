import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/comment/WrittingCommentFloatButton.dart';
import 'package:quenc/widgets/post/PostLikeAndSaveIconsRow.dart';

class PostDetailScreenBottomNavigationBar extends StatelessWidget {
  const PostDetailScreenBottomNavigationBar({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        color: Theme.of(context).secondaryHeaderColor,
        elevation: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: WritingCommentFloatButton(post: post),
            ),
            Flexible(
              flex: 1,
              child: PostLikeAndSaveIconsRow(post: post),
            ),
          ],
        ),
      ),
    );
  }
}
