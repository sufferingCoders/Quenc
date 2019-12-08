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
  String previewPhoto;
  // int likeCount;
  // int archiveCount;
  // int commentCount;
  List<dynamic> likeBy;
  List<dynamic> archiveBy;
  List<dynamic> comments;

  Post({
    this.previewPhoto,
    this.author,
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.likeBy,
    this.archiveBy,
    this.comments,
    this.anonymous,
    this.authorGender,
    this.authorName,
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
      likeBy: data["likeBy"]?.cast<List<String>>() ?? [],
      archiveBy: data["archiveBy"]?.cast<List<String>>() ?? [],
      comments: data["comments"]?.cast<List<String>>() ?? [],
      anonymous: data["anonymous"] ?? true,
      previewPhoto: data["previewPhoto"],
    );
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      "author": author,
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likeBy": likeBy,
      "archiveBy": archiveBy,
      "comments": comments,
      "authorName": authorName,
      "authorGender": authorGender,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
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
      "likeBy": likeBy,
      "archiveBy": archiveBy,
      "comments": comments,
      "authorName": authorName,
      "authorGender": authorGender,
      "anonymous": anonymous,
      "previewPhoto": previewPhoto,
    };
  }
}
