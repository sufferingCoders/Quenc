import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostService.dart';
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
          FutureBuilder(
            future: Provider.of<PostService>(context).getAllPostCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("載入文章分類中"),
                    )); /*  */
              }
              List<PostCategory> categories = snapshot.data;
              if (categories == null || categories.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("未有文章分類"),
                  ),
                ); /*  */
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "文章分類",
                    hintText: "您的文章所屬分類",
                  ),
                  isEmpty: post.category == null,
                  child: DropdownButton<String>(
                    value: post?.category ?? "",
                    onChanged: (v) {
                      post.category = v;
                    },
                    items: categories
                        .map((c) => DropdownMenuItem(
                              child: Text(c.categoryName),
                              value: c.id,
                            ))
                        .toList(),
                  ),
                ),
              );
            },
          ),
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
