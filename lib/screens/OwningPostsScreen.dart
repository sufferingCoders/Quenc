import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
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
      body: Consumer<UserGolangService>(
        builder: (ctx, userService, ch) {
          return FutureBuilder(
            future: Provider.of<PostGolangService>(context)
                .getPostForAuthor(userService.user.id),
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
