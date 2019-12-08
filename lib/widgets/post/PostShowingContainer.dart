import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/PostService.dart';

class PostShowingContainer extends StatefulWidget {
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
    var postService = Provider.of<PostService>(context, listen: false);
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          // LoadingData Here
          postService.getPosts();
        });
      }
    });

    //Loading the initial data here
    if (postService.posts.isEmpty || postService.posts.length == 0) {
      // Initialise it
      postService.initialisePosts();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);

    return ListView.separated(
      separatorBuilder: (context, idx) {
        return Divider(
          color: Colors.grey,
        );
      },
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: postService.posts.length,
      itemBuilder: (ctx, idx) {
        // if (idx == 0) {
        //   return ListTile(
        //     title: Text("${postService?.posts?.toString() ?? ""}"),
        //   );
        // }

        return ListTile(
          isThreeLine: true,
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 10),
                child: Text(
                  "${postService?.posts[idx]?.title ?? ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text("${postService?.posts[idx]?.content ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,

                        //   fontWeight: FontWeight.bold,
                        // ),
                      )))
            ],
          ),
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Icon(
                  Icons.account_circle,
                  color: postService?.posts[idx].authorGender == "male"
                      ? Colors.blue
                      : Colors.pink,
                  size: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text(
                  "${postService?.posts[idx]?.authorName}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
