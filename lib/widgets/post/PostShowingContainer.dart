import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/widgets/post/PostShowingListTile.dart';

class PostShowingContainer extends StatefulWidget {
  final List<Post> posts;
  final Function infiniteScrollUpdater;
  final Function refresh;
  final bool isInit;
  final PostOrderByOption orderBy;
  final Function orderByUpdater;

  PostShowingContainer({
    this.orderBy,
    this.orderByUpdater,
    this.isInit,
    this.refresh,
    this.posts,
    this.infiniteScrollUpdater,
  });

  @override
  _PostShowingContainerState createState() => _PostShowingContainerState();
}

class _PostShowingContainerState extends State<PostShowingContainer> {
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var postService = Provider.of<PostService>(context, listen: false);
    _controller.addListener(
      () {
        var isEnd = _controller.offset == _controller.position.maxScrollExtent;
        if (isEnd) {
          widget.infiniteScrollUpdater();
        }
      },
    );
  }

  Widget getOrderListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: widget.posts.length + 1,
      itemBuilder: (ctx, idx) {
        var theme = Theme.of(context);
        if (idx == 0) {
          return Container(
            color: theme.primaryColorLight,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "排序",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: theme.primaryColorDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<PostOrderByOption>(
                    focusColor: theme.primaryColorDark,
                    value: widget.orderBy,
                    onChanged: (v) {
                      widget.orderByUpdater(v);
                    },
                    items: [
                      DropdownMenuItem(
                        value: PostOrderByOption.LikeCount,
                        child: Text(
                          "熱門",
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: PostOrderByOption.CreatedAt,
                        child: Text(
                          "最新",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: <Widget>[
            PostShowingListTile(post: widget.posts[idx - 1]),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget getWithoutOrderListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: widget.posts.length,
      itemBuilder: (ctx, idx) {
        return Column(
          children: <Widget>[
            PostShowingListTile(post: widget.posts[idx]),
            const Divider(),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.posts == null) {
      if (widget.isInit == false) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("無貼文"),
              FlatButton(
                child: Text("重新整理"),
                onPressed: () {
                  widget.refresh();
                },
              )
            ],
          ),
        );
      }
    }

    return widget.orderBy != null && widget.orderByUpdater != null
        ? getOrderListView()
        : getWithoutOrderListView();
  }
}
