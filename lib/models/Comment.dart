import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

class Comment {
  // Schema for saving the comment in Firestore

  String id;
  User author;
  String belongPost;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> likers;
  int likeCount;

  Comment({
    this.id,
    this.belongPost,
    this.author,
    this.content,
    this.likers,
    this.createdAt,
    this.updatedAt,
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

  factory Comment.fromMap(Map data) {
    return Comment(
      id: data["_id"],
      author: User.fromMap(data["author"]),
      belongPost: data["belongPost"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      updatedAt: Utils.getDateTime(data["updatedAt"]),
      likers: data["likers"],
      likeCount: data["likeCount"],
    );
  }

  Map<String, dynamic> toAddingMap() {
    return {
      "_id": id,
      "author": author,
      "author": author.id,
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likers": likers,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "author": author,
      "author": author.toMap(),
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likers": likers,
      "likeCount": likeCount,
    };
  }
}
