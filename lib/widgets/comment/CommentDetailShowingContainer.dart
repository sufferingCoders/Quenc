import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/utils/index.dart';

class CommentDetailShowingContainer extends StatelessWidget {
  CommentDetailShowingContainer({
    Key key,
    @required this.comment,
    this.post,
  }) : super(key: key);
  final Post post;

  final UserService userService = UserService();

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: comment.authorGender == 1 ? Colors.blue : Colors.pink,
                size: 35,
              ),
              isThreeLine: true,
              title: Text(
                post?.author == comment?.author
                    ? "作者"
                    : Utils.getDisplayNameFromDomain(comment.authorDomain),
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              subtitle: Text(
                "${DateFormat("h:mm a   dd, MMM, yyyy").format(comment.createdAt)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: Consumer<User>(
                builder: (ctx, user, ch) {
                  return IconButton(
                    color: user.likeComments.contains(comment.id)
                        ? Colors.pink
                        : Colors.grey,
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      if (comment.id != null) {
                        userService.toggleCommentLike(
                          comment.id,
                          user,
                        );
                      }
                    },
                  );
                },
              )),
        ),
      ],
    );
  }
}
