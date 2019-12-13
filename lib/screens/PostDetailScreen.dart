import 'package:clipboard_manager/clipboard_manager.dart' as cm;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as mk;
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/widgets/comment/CommentAddingFullScreenDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatelessWidget {
  static const routeName = "/post/detail";
  final String postId;
  Post post;
  final userService = UserService();

  // Also have to show the comments

  PostDetailScreen({this.postId});

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);

    return FutureBuilder<Object>(
      future: postService.getPostByID(postId),
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
          bottomNavigationBar: Transform.translate(
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: BottomAppBar(
              color: Theme.of(context).secondaryHeaderColor,
              elevation: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: FlatButton(
                      child: Wrap(
                        children: <Widget>[
                          Icon(Icons.account_circle),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Consumer<User>(
                      builder: (context, user, ch) => Row(
                        // mainAxisAlignment: MainAxisAlignment.start,

                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.favorite),
                              color: user.likePosts.contains(post?.id)
                                  ? Colors.pink
                                  : Colors.grey,
                              onPressed: () {
                                userService.togglePostLike(postId, user);
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.save),
                              color: user.archivePosts.contains(post.id)
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: () {
                                userService.togglePostArchive(postId, user);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsSrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("${post.title}"),
                  floating: true,
                  snap: true,
                  centerTitle: true,
                ),
              ];
            },
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: post.authorGender == "male"
                          ? Colors.blue
                          : Colors.pink,
                      size: 35,
                    ),
                    // isThreeLine: true,
                    title: Text(
                      "${post.authorName}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    // subtitle: Text("${post.authorName}"),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
                  child: Text(
                    "${post.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
                  child: Text(
                    "${DateFormat("h:mm a   dd, MMM, yyyy").format(post.createdAt)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
                  child: Builder(
                    builder: (context) {
                      // var match = imageReg.firstMatch(post.content);
                      // String firstImageUrl =
                      //     post.content.substring(match.start, match.end);
                      // print(firstImageUrl);
                      // int idxStart = firstImageUrl.indexOf("(");
                      // var retrievedURL = firstImageUrl.substring(idxStart+1, firstImageUrl.length-1);
                      var mdText = mk.markdownToHtml(
                        post.content.replaceAll("\n", "</br>"),
                        extensionSet: mk.ExtensionSet.gitHubWeb,
                      );
                      // return Html(
                      //   useRichText: true,
                      //   data: mdText,
                      // );
                      // );
                      return HtmlWidget(
                        mdText,
                        onTapUrl: (url) async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            cm.ClipboardManager.copyToClipBoard(url).then((r) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("無法顯示此網址, 但已將此網址複製至剪貼簿"),
                                duration: Duration(
                                  seconds: 3,
                                ),
                              ));
                            });
                          }
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(
                    color: Colors.black,
                    indent: 10,
                    endIndent: 10,
                    height: 5,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                ),
                // Showing the comment here

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(
                    color: Colors.black,
                    indent: 10,
                    endIndent: 10,
                    height: 5,
                  ),
                ),
                FutureBuilder(
                  future:
                      Provider.of<CommentService>(context).getCommentForPost(
                    post.id,
                    orderBy: CommentOrderByOptions.ByCreatedAt,
                  ),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            child: Text("載入評論中"),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            child: Text("評論載入錯誤"),
                          ),
                        ),
                      );
                    }

                    if (snapshot.data == null || snapshot.data?.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            child: Text("未有評論"),
                          ),
                        ),
                      );
                    }

                    List<Widget> allComments = [];
                    List<Comment> retrievedComments = snapshot.data;
                    for (var c in retrievedComments) {
                      allComments.add(Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: ListTile(
                                  leading: Icon(
                                    Icons.account_circle,
                                    color: c.authorGender == "male"
                                        ? Colors.blue
                                        : Colors.pink,
                                    size: 35,
                                  ),
                                  isThreeLine: true,
                                  title: Text(
                                    "${c.authorName}",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${DateFormat("h:mm a   dd, MMM, yyyy").format(c.createdAt)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: Consumer<User>(
                                    builder: (ctx, user, ch) {
                                      return IconButton(
                                        color: user.likeComments.contains(c.id)
                                            ? Colors.pink
                                            : Colors.grey,
                                        icon: Icon(Icons.favorite),
                                        onPressed: () {
                                          userService.toggleCommentLike(
                                            c.id,
                                            user,
                                          );
                                        },
                                      );
                                    },
                                  )
                                  // subtitle: Text("${post.authorName}"),
                                  ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 4.0),
                                child: Builder(
                                  builder: (context) {
                                    var mdText = mk.markdownToHtml(
                                      c.content.replaceAll("\n", "</br>"),
                                      extensionSet: mk.ExtensionSet.gitHubWeb,
                                    );
                                    // return Html(
                                    //   useRichText: true,
                                    //   data: mdText,
                                    // );
                                    // );
                                    return HtmlWidget(
                                      mdText,
                                      onTapUrl: (url) async {
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          cm.ClipboardManager.copyToClipBoard(
                                                  url)
                                              .then((r) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("無法顯示此網址, 但已將此網址複製至剪貼簿"),
                                              duration: Duration(
                                                seconds: 3,
                                              ),
                                            ));
                                          });
                                        }
                                      },
                                    );
                                  },
                                )),
                            const Divider(
                              color: Colors.black,
                              indent: 10,
                              endIndent: 10,
                              height: 3,
                            ),
                          ],
                        ),
                      ));
                    }

                    return Column(
                      children: <Widget>[
                        ...allComments,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
