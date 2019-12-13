import 'package:flutter/material.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/widgets/common/ContentEditingContainer.dart';
import 'package:quenc/widgets/post/TitleEditingTextField.dart';

class PostEditingForm extends StatelessWidget {
  const PostEditingForm({
    Key key,
    @required GlobalKey<FormState> form,
    @required this.post,
    @required this.contentController,
  })  : _form = form,
        super(key: key);

  final GlobalKey<FormState> _form;
  final Post post;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TitleEditingTextField(post: post),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: CheckboxListTile(
                    secondary: Text("匿名"),
                    value: post.anonymous,
                    onChanged: (v) {
                      post.anonymous = v;
                    },
                  ),
                )
              ],
            ),
          ),
          ContentEditingContainer(
            contentController: contentController,
            post: post,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
          )
        ],
      ),
    );
  }
}
