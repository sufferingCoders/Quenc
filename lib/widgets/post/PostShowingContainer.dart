import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/screens/PostDetailScreen.dart';

class PostShowingContainer extends StatefulWidget {
  final List<Post> posts;
  final Function infiniteScrollUpdater;

  PostShowingContainer({
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
          // setState(() {
          //   // LoadingData Here
          //   postService.getPosts();
          // });
          widget.infiniteScrollUpdater();
        }
      },
    );

    //Loading the initial data here
    // if (postService.posts == null ||
    //     postService.posts.isEmpty ||
    //     postService.posts.length == 0) {
    //   // Initialise it
    //   postService.initialisePosts();
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var postService = Provider.of<PostService>(context);

    // if (!postService.postIsInit) {
    //   postService.tryInitPosts();
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    if (widget.posts == null) {
      return Center(
        child: Text("無貼文"),
      );
    }

    return ListView.builder(
      // separatorBuilder: (context, idx) {
      //   return Divider(
      //     color: Colors.grey,
      //   );
      // },
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: widget.posts.length,
      itemBuilder: (ctx, idx) {
        // if (idx == 0) {
        //   return ListTile(
        //     title: Text("${postService?.posts?.toString() ?? ""}"),
        //   );
        // }

        return Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(
                  PostDetailScreen.routeName,
                  arguments: widget.posts[idx].id,
                );
              },
              isThreeLine: true,
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 5),
                    child: Text(
                      "${widget.posts[idx]?.title ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  if (widget.posts[idx]?.previewText != null &&
                      widget.posts[idx]?.previewText?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 5),
                      child: Text(
                        "${widget.posts[idx]?.previewText ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,

                          //   fontWeight: FontWeight.bold,
                          // ),
                        ),
                      ),
                    )
                ],
              ),
              title: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 3.0, top: 8.0),
                    child: Icon(
                      Icons.account_circle,
                      color: widget.posts[idx].authorGender == "male"
                          ? Colors.blue
                          : Colors.pink,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 3.0, right: 8.0, top: 8.0),
                      child: Text(
                        "${widget.posts[idx]?.authorName}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Builder(builder: (context) {
                String photo = widget.posts[idx]?.previewPhoto;

                if (photo == null) {
                  return Container();
                }

                return Image.network(
                  widget.posts[idx]?.previewPhoto,
                  fit: BoxFit.fill,
                );

                // return postService?.posts[idx]?.previewPhoto != null
                //     ? Image.network(postService?.posts[idx]?.previewPhoto)
                //     : Container();
              }),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
