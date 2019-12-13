import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quenc/models/Post.dart';

class PostDetailShowingColumn extends StatelessWidget {
  const PostDetailShowingColumn({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

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
              color: post.authorGender == "male" ? Colors.blue : Colors.pink,
              size: 35,
            ),
            title: Text(
              "${post.authorName}",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
          child: Text(
            "${post.title}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
          child: Text(
            "${DateFormat("h:mm a   dd, MMM, yyyy").format(post.createdAt)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
