import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserService.dart';

// enum PostCardMode {
//   Editing,
//   Adding,
// }

class PostAddingAndEditingCard extends StatefulWidget {
  Post post;
  // PostCardMode mode;
  Function submitController;

  PostAddingAndEditingCard({this.post, this.submitController}) {
    if (post != null) {
      // Should be Editing mode
      // mode = PostCardMode.Editing;
    } else {
      // Should be Adding mode
      // mode = PostCardMode.Adding;
      post = Post(
        anonymous: false,
        title: "",
        content: "",
        // comments: [],
        // archiveBy: [],
        // likeBy: [],
      );
    }
  }

  @override
  _PostAddingAndEditingCardState createState() =>
      _PostAddingAndEditingCardState();
}

class _PostAddingAndEditingCardState extends State<PostAddingAndEditingCard> {
  final _form = GlobalKey<FormState>();

  void addPost(BuildContext ctx, Post post) async {
    // Initialise the fields
    post.author = Provider.of<User>(ctx, listen: false).id;
    post.createdAt = DateTime.now();
    post.updatedAt = DateTime.now();

    // Add to the post collection
    String postID = await Provider.of<PostService>(ctx).addPost(post);

    // Add to the user collection
    UserService().addPostToUser(
      postID,
      post.author,
    );

    Navigator.of(ctx).pop();
  }

  void editPost(BuildContext ctx) {
    widget.post.updatedAt = DateTime.now();

    // Edit the posts in Collection
    Provider.of<PostService>(context).editPost(widget.post);

    Navigator.of(ctx).pop();
  }

  void _submit(BuildContext ctx) {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    widget.submitController(context, widget.post);
    // if (widget.mode == PostCardMode.Editing) {
    //   editPost(ctx);
    // } else if (widget.mode == PostCardMode.Adding) {
    //   addPost(ctx);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.post.title,
                decoration: const InputDecoration(
                  labelText: "標題",
                  border: const OutlineInputBorder(),
                ),
                onSaved: (v) {
                  widget.post.title = v;
                },
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "請輸入標題";
                  }

                  if (v.length > 20) {
                    return "標題不可多於20個字元";
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.post.title,
                minLines: 5,
                maxLines: 20,
                decoration: const InputDecoration(
                  labelText: "內容",
                  border: const OutlineInputBorder(),
                ),
                onSaved: (v) {
                  // Adding the Markdown parserr here
                  widget.post.content = v;
                },
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "請輸入內容";
                  }

                  if (v.length < 20) {
                    return "內容必須多餘20個字元";
                  }

                  return null;
                },
              ),
            ),
            ListTile(
              trailing: RaisedButton(
                child: Text(" 發表"),
                onPressed: () {
                  // Create and Adding the Post here
                  _submit(context);
                },
              ),
              leading: Checkbox(
                value: widget.post.anonymous,
                onChanged: (v) {
                  setState(() {
                    widget.post.anonymous = v;
                  });
                },
              ),
              title: Text(
                "匿名發文",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
