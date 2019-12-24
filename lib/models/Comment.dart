import 'package:quenc/models/User.dart';

class Comment {
  // Schema for saving the comment in Firestore

  String id;
  User author;
  String belongPost;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> likers;

  Comment({
    this.id,
    this.belongPost,
    this.author,
    this.content,
    this.likers,
    this.createdAt,
    this.updatedAt,
  });

  int get likeCount {
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
        id: data["id"],
        author: User.fromMap(data["author"]),
        belongPost: data["belongPost"],
        content: data["content"],
        createdAt: data["createdAt"].toDate() ?? DateTime.now(),
        updatedAt: data["updatedAt"].toDate() ?? DateTime.now(),
        likers: data["likers"]);
  }

  Map<String, dynamic> toAddingMap() {
    return {
      "id": id,
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
      "id": id,
      "author": author,
      "author": author.toMap(),
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likers": likers,
    };
  }
}
