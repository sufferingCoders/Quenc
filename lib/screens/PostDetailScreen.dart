import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/providers/CommentGolangService.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/widgets/comment/CommentShowingFutureBuilder.dart';
import 'package:quenc/widgets/common/CommentDivider.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';
import 'package:quenc/widgets/post/PostDetailScreenButtonNavigationBar.dart';
import 'package:quenc/widgets/post/PostDetailShowingColumn.dart';
import 'package:quenc/widgets/post/ScrollHideSliverAppBar.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = "/post/detail";
  final String postId;

  PostDetailScreen({this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post post;

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostGolangService>(context);
    return FutureBuilder<Object>(
      future: postService.getPostByID(widget.postId),
      builder: (context, retrievedPostSnapshot) {
        if (retrievedPostSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        post = retrievedPostSnapshot.data;

        return Scaffold(
          bottomNavigationBar: PostDetailScreenBottomNavigationBar(post: post),
          body: NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsSrolled) {
              return <Widget>[
                ScrollHideSliverAppBar(titleText: post?.title ?? "貼文不存在"),
              ];
            },
            body: post == null
                ? Center(
                    child: Text("此篇貼文已經不存在"),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PostDetailShowingColumn(post: post),
                        ContentShowingContainer(content: post?.content),
                        CommentDivider(text: "熱門回文"),
                        CommentShowingFutureBuilder(
                          Provider.of<CommentGolangService>(context,
                                  listen: false)
                              .getTopLikedCommentsForPost(post.id, 3),
                          post: post,
                        ),
                        CommentDivider(text: "全部回文"),
                        CommentShowingFutureBuilder(
                          Provider.of<CommentGolangService>(context)
                              .getCommentForPost(
                            pid: post.id,
                            orderBy: OrderByOption.CreatedAt,
                          ),
                          post: post,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
