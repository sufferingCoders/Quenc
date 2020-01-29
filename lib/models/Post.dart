import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

/// Schema for saving the Post in backend
class Post {
  String id;
  User author;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool anonymous;
  String previewText;
  String previewPhoto;
  PostCategory category;
  List<String> likers;
  int likeCount;

  Post({
    this.previewPhoto,
    this.author,
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.anonymous,
    this.previewText,
    this.likers,
    this.likeCount,
  });

  int get likeCountFromLikers {
    return likers?.length;
  }

  String get authorDomain {
    return author.domain;
  }

  int get authorGender {
    return author.gender;
  }

  factory Post.fromMap(dynamic data) {
    return Post(
      id: data["_id"],
      author: User.fromMap(data["author"]),
      title: data["title"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      updatedAt: Utils.getDateTime(data["updatedAt"]),
      anonymous: data["anonymous"],
      previewPhoto: data["previewPhoto"],
      previewText: data["previewText"],
      category: PostCategory.fromMap(data["category"]),
      likers: data["likers"]?.cast<String>(),
      likeCount: data["likeCount"],
    );
  }

  // Adding map will be sent to backend to add a new post
  Map<String, dynamic> toAddingMap() {
    // Author to
    return {
      "title": title,
      "content": content,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "category": category.id,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "author": author?.toMap(),
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "category": category?.toMap(),
      "likers": likers,
      "likeCount": likeCount,
    };
  }
}
