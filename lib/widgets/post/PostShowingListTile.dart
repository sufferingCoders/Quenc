import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/screens/PostDetailScreen.dart';
import 'package:quenc/utils/index.dart';

class PostShowingListTile extends StatelessWidget {
  const PostShowingListTile({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    Function idToName =
        Provider.of<PostGolangService>(context).getCategoryNameByID;
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostDetailScreen.routeName,
          arguments: post.id,
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
              "${post?.title ?? ""}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
          if (post?.previewText != null &&
              post?.previewText?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 5),
              child: Text(
                "${post?.previewText ?? ""}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            )
        ],
      ),
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 3.0, top: 8.0),
            child: Icon(
              Icons.account_circle,
              color: post.authorGender == 1 ? Colors.blue : Colors.pink,
              size: 16,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 8.0, top: 8.0),
              child: Text(
                "${post?.category?.categoryName ?? ""}  -  ${post.anonymous == true ? "匿名" : Utils.getDisplayNameFromDomain(post.authorDomain)}",
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
        String photo = post?.previewPhoto;

        if (photo == null || photo.isEmpty) {
          return Container(
            height: 1,
            width: 1,
          );
        }

        return Image.network(
          post?.previewPhoto,
          fit: BoxFit.fill,
        );
      }),
    );
  }
}
