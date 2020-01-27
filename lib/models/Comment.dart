import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

/// Schema for saving the comments in Backend
class Comment {
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

  /// Get Number of Likes for this Comment
  int get likeCountFromLikers {
    return likers?.length;
  }

  /// Get the domain of the author
  String get authorDomain {
    return author.domain;
  }

  /// Get the Gender of the author
  int get authorGender {
    return author.gender;
  }

  factory Comment.fromMap(dynamic data) {
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

  /// To add the map only need belongPost and content fields
  Map<String, dynamic> toAddingMap() {
    return {
      "belongPost": belongPost,
      "content": content,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "author": author,
      "author": author?.toMap(),
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likers": likers,
      "likeCount": likeCount,
    };
  }
}
