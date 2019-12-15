import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/post/PostAddingFullScreenDialog.dart';

class PostDetailShowingColumn extends StatelessWidget {
  const PostDetailShowingColumn({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    Function idToName = Provider.of<PostService>(context).getCategoryNameByID;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: Icon(
              Icons.account_circle,
              color: post.authorGender == 1 ? Colors.blue : Colors.pink,
              size: 35,
            ),
            title: Text(
              Utils.getDisplayNameFromDomain(post.authorDomain),
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            trailing: Consumer<User>(
              builder: (ctx, user, ch) {
                if (user.uid == post.author) {
                  return IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            final dialog = PostAddingFullScreenDialog(
                              post: post,
                            );
                            return dialog;
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
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
            "${idToName(post.category)}  -  ${DateFormat("h:mm a   dd, MMM, yyyy").format(post.createdAt)}",
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
