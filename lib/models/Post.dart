class Post {
  String id;
  String author;
  String authorName; // For displaying
  String authorGender; // For displaying
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool anonymous;
  String previewText;
  String previewPhoto;
  int likeCount;
  int archiveCount;
  int commentCount;
  String category; // 0 為其它
  // 文章的Category該用int還String? // int 節省存儲成本
  // List<dynamic> likeBy;
  // List<dynamic> archiveBy;
  // List<dynamic> comments;

  Post({
    this.previewPhoto,
    this.author,
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.category,
    // this.likeBy,
    // this.archiveBy,
    // this.comments,
    this.anonymous,
    this.authorGender,
    this.authorName,
    this.previewText,
    this.likeCount,
    this.archiveCount,
    this.commentCount,
  });

  factory Post.fromMap(Map data) {
    return Post(
      id: data["id"] ?? "",
      authorName: data["authorName"] ?? "",
      authorGender: data["authorGender"] ?? "",
      author: data["author"] ?? "",
      title: data["title"] ?? "",
      content: data["content"] ?? "",
      createdAt: data["createdAt"]?.toDate() ?? DateTime.now(),
      updatedAt: data["updatedAt"]?.toDate() ?? DateTime.now(),
      // likeBy: data["likeBy"]?.cast<List<String>>() ?? [],
      // archiveBy: data["archiveBy"]?.cast<List<String>>() ?? [],
      // comments: data["comments"]?.cast<List<String>>() ?? [],
      anonymous: data["anonymous"] ?? true,
      previewPhoto: data["previewPhoto"],
      previewText: data["previewText"] ?? "",
      likeCount: data["likeCount"] ?? 0,
      archiveCount: data["archiveCount"] ?? 0,
      category: data["category"] ?? "",
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      "author": author,
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      // "likeBy": likeBy,
      // "archiveBy": archiveBy,
      // "comments": comments,
      "authorName": authorName,
      "authorGender": authorGender,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "likeCount": likeCount,
      "archiveCount": archiveCount,
      "category": category,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "author": author,
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      // "likeBy": likeBy,
      // "archiveBy": archiveBy,
      // "comments": comments,
      "authorName": authorName,
      "authorGender": authorGender,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "likeCount": likeCount,
      "category": category,
    };
  }
}
