import 'package:flutter/material.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/comment/CommentShowingColumn.dart';

class CommentShowingWithRetrieivingFunc extends StatefulWidget {
  final Post post;
  final Function retrievingFunc;
  CommentShowingWithRetrieivingFunc(
    this.retrievingFunc, {
    this.post,
  });

  @override
  _CommentShowingWithRetrieivingFuncState createState() =>
      _CommentShowingWithRetrieivingFuncState();
}

class _CommentShowingWithRetrieivingFuncState
    extends State<CommentShowingWithRetrieivingFunc> {
  bool initStart = false;
  bool initEnd = false;

  List<Widget> allComments = [];
  List<Comment> retrievedComments;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!initStart) {
      setState(() {
        initStart = true;
        retreivingData();
      });
    }
    super.didChangeDependencies();
  }

  void retreivingData() {
    widget.retrievingFunc().then((v) {
      setState(() {
        retrievedComments = v;
        for (var c in retrievedComments) {
          allComments.add(Container(
            child: CommentShowingColumn(comment: c, post: widget.post),
          ));
        }
        initEnd = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initEnd) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Text("載入評論中"),
          ),
        ),
      );
    }

    if (initEnd &&
        (retrievedComments == null || retrievedComments?.isEmpty == true)) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Text("未有評論"),
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        ...allComments,
      ],
    );
  }
}
