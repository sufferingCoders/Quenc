import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

/// This screen show all the saved post
class OwingPostsScreen extends StatelessWidget {
  static const routeName = "/owing";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的帖子"),
      ),
      body: Consumer<User>(
        builder: (ctx, user, ch) {
          if (user.archivePosts == null || user.archivePosts.isEmpty) {
            return Center(
              child: Text("還未有帖子"),
            );
          }

          return FutureBuilder(
            future: Provider.of<PostService>(context).getPostForUser(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Post> retrievedPosts = snapshot.data;

              if (retrievedPosts == null || retrievedPosts.isEmpty) {
                return Center(
                  child: Text("還未有帖子"),
                );
              }

              return PostShowingContainer(
                posts: retrievedPosts,
              );
            },
          );
        },
      ),
    );
  }
}
