class Comment {
  String id;
  String author;
  String authorName;
  String authorGender;
  String belongPost;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int likeCount;

  Comment({
    this.id,
    this.author,
    this.authorName,
    this.authorGender,
    this.belongPost,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
  });

  factory Comment.fromMap(Map data) {
    return Comment(
      id: data["id"] ?? "",
      author: data["authorName"] ?? "",
      authorGender: data["authorGender"] ?? "",
      authorName: data["authorName"] ?? "",
      belongPost: data["belongPost"] ?? "",
      content: data["content"] ?? "",
      createdAt: data["createdAt"].toDate() ?? DateTime.now(),
      updatedAt: data["updatedAt"].toDate() ?? DateTime.now(),
      likeCount: data["likeCount"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "author": author,
      "authorGender": authorGender,
      "authorName": authorName,
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likeCount": likeCount,
    };
  }
}
