import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';

class TitleEditingTextField extends StatelessWidget {
  const TitleEditingTextField({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: post.title,
      decoration: const InputDecoration(
        // labelText: "標題",
        border: InputBorder.none,
        hintText: "標題",
        // border: const OutlineInputBorder(),
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
    );
  }
}
