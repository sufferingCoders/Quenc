import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserService.dart';

// This one should be able for editing and addding
class PostAddingFullScreenDialog extends StatefulWidget {
  @override
  _PostAddingFullScreenDialogState createState() =>
      _PostAddingFullScreenDialogState();
}

class _PostAddingFullScreenDialogState
    extends State<PostAddingFullScreenDialog> {
  final _form = GlobalKey<FormState>();

  Post post = Post(
    anonymous: false,
    title: "",
    content: "",
    comments: [],
    archiveBy: [],
    likeBy: [],
  );

  void _submit(BuildContext ctx) {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();
    addPost(context);
  }

  void addPost(BuildContext ctx) async {
    // Initialise the fields
    post.author = Provider.of<User>(ctx, listen: false).uid;
    post.createdAt = DateTime.now();
    post.updatedAt = DateTime.now();

    // Add to the post collection
    String postID =
        await Provider.of<PostService>(ctx, listen: false).addPost(post);

    // Add to the user collection
    Provider.of<UserService>(ctx).addPostToUser(postID, post.author);

    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增文章"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("發表"),
              onPressed: () {
                _submit(context);
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: post.title,
                      decoration: const InputDecoration(
                        labelText: "標題",
                        border: const OutlineInputBorder(),
                      ),
                      onSaved: (v) {
                        post.title = v;
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
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: CheckboxListTile(
                    secondary: Text("匿名"),
                    // title: Text("匿名"),
                    value: post.anonymous,
                    onChanged: (v) {
                      setState(() {
                        post.anonymous = v;
                      });
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: post.title,
                  minLines: 5,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    labelText: "內容",
                    border: const OutlineInputBorder(),
                  ),
                  onSaved: (v) {
                    // Adding the Markdown parserr here
                    post.content = v;
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
            ),
          ],
        ),
      ),
    );
  }
}
