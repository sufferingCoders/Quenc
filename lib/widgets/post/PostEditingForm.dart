import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/widgets/common/ContentEditingContainer.dart';
import 'package:quenc/widgets/post/TitleEditingTextField.dart';

class PostEditingForm extends StatefulWidget {
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
  _PostEditingFormState createState() => _PostEditingFormState();
}

class _PostEditingFormState extends State<PostEditingForm> {
  List<PostCategory> categories;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      setCategories();
    }
  }

  void setCategories() {
    Provider.of<PostGolangService>(context).getAllPostCategories().then((cat) {
      setState(() {
        categories = cat;
        isInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._form,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          if (categories != null && categories.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("分類:"),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: widget.post?.category,
                      onChanged: (v) {
                        setState(() {
                          widget.post.category = v;
                        });
                      },
                      items: categories
                          .map((c) => DropdownMenuItem(
                                child: Text(c.categoryName),
                                value: c.id,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TitleEditingTextField(post: widget.post),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: CheckboxListTile(
                    secondary: Text("匿名"),
                    value: widget.post.anonymous,
                    onChanged: (v) {
                      setState(() {
                        widget.post.anonymous = v;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          ContentEditingContainer(
            contentController: widget.contentController,
            post: widget.post,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
          )
        ],
      ),
    );
  }
}
