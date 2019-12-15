import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/post/PostShowingListTile.dart';

class PostShowingContainer extends StatefulWidget {
  final List<Post> posts;
  final Function infiniteScrollUpdater;
  final Function refresh;
  final bool isInit;

  PostShowingContainer({
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
}
