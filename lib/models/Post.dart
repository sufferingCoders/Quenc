class Post {
  String id;
  String author;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool anonymous;
  // int likeCount;
  // int archiveCount;
  // int commentCount;
  List<String> likeBy;
  List<String> archiveBy;
  List<String> comments;

  Post(
      {this.author,
      this.id,
      this.title,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.likeBy,
      this.archiveBy,
      this.comments,
      this.anonymous});

  factory Post.fromMap(Map data) {
    return Post(
      id: data["id"] ?? "",
      author: data["author"] ?? "",
      title: data["title"] ?? "",
      content: data["content"] ?? "",
      createdAt: data["createdAt"] ?? DateTime.now(),
      updatedAt: data["updatedAt"] ?? DateTime.now(),
      likeBy: data["likeBy"] ?? [],
      archiveBy: data["archiveBy"] ?? [],
      comments: data["comments"] ?? [],
      anonymous: data["anonymous"] ?? true,
    );
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
      "anonymous": anonymous,
    };
  }
}
