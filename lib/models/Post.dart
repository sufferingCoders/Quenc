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

/**
 * Post for FireStore
 */

// class Post {
//   // Schema for saving the Post in Firestore

//   String id;
//   String author;
//   String authorDomain;
//   int authorGender;
//   String title;
//   String content;
//   DateTime createdAt;
//   DateTime updatedAt;
//   bool anonymous;
//   String previewText;
//   String previewPhoto;
//   int likeCount;
//   String category;
//   // int archiveCount;
//   // int commentCount;

//   Post({
//     this.previewPhoto,
//     this.author,
//     this.id,
//     this.title,
//     this.content,
//     this.createdAt,
//     this.updatedAt,
//     this.category,
//     this.anonymous,
//     this.authorGender,
//     this.authorDomain,
//     this.previewText,
//     this.likeCount,
//     // this.archiveCount,
//     // this.commentCount,
//   });

//   factory Post.fromMap(Map data) {
//     return Post(
//       id: data["id"],
//       authorDomain: data["authorDomain"],
//       authorGender: data["authorGender"],
//       author: data["author"],
//       title: data["title"],
//       content: data["content"],
//       createdAt: data["createdAt"]?.toDate() ?? DateTime.now(),
//       updatedAt: data["updatedAt"]?.toDate() ?? DateTime.now(),
//       anonymous: data["anonymous"] ?? true,
//       previewPhoto: data["previewPhoto"],
//       previewText: data["previewText"],
//       likeCount: data["likeCount"] ?? 0,
//       // archiveCount: data["archiveCount"] ?? 0,
//       // commentCount: data["commentCount"] ?? 0,

//       category: data["category"],
//     );
//   }

//   Map<String, dynamic> toMapWithoutId() {
//     return {
//       "author": author,
//       "title": title,
//       "content": content,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "authorDomain": authorDomain,
//       "authorGender": authorGender,
//       "anonymous": anonymous,
//       "previewPhoto": previewPhoto,
//       "previewText": previewText,
//       "likeCount": likeCount,
//       // "archiveCount": archiveCount,
//       // "commentCount": commentCount,
//       "category": category,
//     };
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "author": author,
//       "title": title,
//       "content": content,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "authorDomain": authorDomain,
//       "authorGender": authorGender,
//       "anonymous": anonymous,
//       "previewPhoto": previewPhoto,
//       "previewText": previewText,
//       "likeCount": likeCount,
//       "category": category,
//     };
//   }
// }
