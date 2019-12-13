import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/widgets/post/PostShowingContainer.dart';

class ArchivePostScreen extends StatelessWidget {
  static const routeName = "/archive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已收藏"),
      ),
      body: Consumer<User>(
        builder: (ctx, user, ch) {
          if (user.archivePosts == null || user.archivePosts.isEmpty) {
            return Center(
              child: Text("還未有收藏"),
            );
          }

          return FutureBuilder(
            future: Provider.of<PostService>(context)
                .getMultiplePostsByIds(user.archivePosts),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Post> retrievedPosts = snapshot.data;

              if (retrievedPosts == null || retrievedPosts.isEmpty) {
                return Center(
                  child: Text("還未有收藏"),
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
