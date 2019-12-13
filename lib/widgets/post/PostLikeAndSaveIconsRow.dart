import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';

class PostLikeAndSaveIconsRow extends StatelessWidget {
  PostLikeAndSaveIconsRow({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, ch) => Row(
        // mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.favorite),
              color:
                  user.likePosts.contains(post?.id) ? Colors.pink : Colors.grey,
              onPressed: () {
                userService.togglePostLike(post.id, user);
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.bookmark),
              color: user.archivePosts.contains(post.id)
                  ? Colors.blue
                  : Colors.grey,
              onPressed: () {
                userService.togglePostArchive(post.id, user);
              },
            ),
          )
        ],
      ),
    );
  }
}
