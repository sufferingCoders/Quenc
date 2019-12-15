class Comment {
  // Schema for saving the comment in Firestore

  String id;
  String author;
  String authorDomain;
  int authorGender;
  String belongPost;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int likeCount;

  Comment({
    this.id,
    this.author,
    this.authorDomain,
    this.authorGender,
    this.belongPost,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
  });

  factory Comment.fromMap(Map data) {
    return Comment(
      id: data["id"],
      author: data["authorDomain"],
      authorGender: data["authorGender"],
      authorDomain: data["authorDomain"],
      belongPost: data["belongPost"],
      content: data["content"],
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
      "authorDomain": authorDomain,
      "belongPost": belongPost,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likeCount": likeCount,
    };
  }
}
