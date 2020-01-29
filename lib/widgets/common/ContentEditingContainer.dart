import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';

class ContentEditingContainer extends StatelessWidget {
  const ContentEditingContainer({
    Key key,
    @required this.contentController,
    @required this.post,
  }) : super(key: key);

  final TextEditingController contentController;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        minLines: 4,
        controller: contentController,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "內容 (內容必須多餘20個字元)",
          border: InputBorder.none,
        ),
        onSaved: (v) {
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
    );
  }
}
