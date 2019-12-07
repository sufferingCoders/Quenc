class Post {
  String author;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  // int likeCount;
  // int archiveCount;
  // int commentCount;
  List<String> likeBy;
  List<String> archiveBy;
  List<String> comments;

  Post({
    this.author,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.likeBy,
    this.archiveBy,
    this.comments,
  });

  factory Post.fromMap(Map data) {
    return Post(
      author: data["author"] ?? "",
      title: data["title"] ?? "",
      content: data["content"] ?? "",
      createdAt: data["createdAt"] ?? DateTime.now(),
      updatedAt: data["updatedAt"] ?? DateTime.now(),
      likeBy: data["likeBy"] ?? [],
      archiveBy: data["archiveBy"] ?? [],
      comments: data["comments"] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "author": author,
      "title": title,
      "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "likeBy": likeBy,
      "archiveBy": archiveBy,
      "comments": comments,
    };
  }
}
