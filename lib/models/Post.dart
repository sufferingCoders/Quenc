class Post {
  // Schema for saving the Post in Firestore

  String id;
  String author;
  String authorDomain;
  int authorGender;
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
    this.authorGender,
    this.authorDomain,
    this.previewText,
    this.likeCount,
    this.archiveCount,
    this.commentCount,
  });

  factory Post.fromMap(Map data) {
    return Post(
      id: data["id"],
      authorDomain: data["authorDomain"],
      authorGender: data["authorGender"],
      author: data["author"],
      title: data["title"],
      content: data["content"],
      createdAt: data["createdAt"]?.toDate() ?? DateTime.now(),
      updatedAt: data["updatedAt"]?.toDate() ?? DateTime.now(),
      anonymous: data["anonymous"] ?? true,
      previewPhoto: data["previewPhoto"],
      previewText: data["previewText"],
      likeCount: data["likeCount"] ?? 0,
      archiveCount: data["archiveCount"] ?? 0,
      category: data["category"],
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      "author": author,
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "authorDomain": authorDomain,
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
      "authorDomain": authorDomain,
      "authorGender": authorGender,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "likeCount": likeCount,
      "category": category,
    };
  }
}
