class PostCategory {
  // Category for Post

  String id;
  String categoryName;

  PostCategory({
    this.categoryName,
    this.id,
  });

  factory PostCategory.fromMap(dynamic data) {
    return PostCategory(
      id: data["_id"] ?? "",
      categoryName: data["categoryName"] ?? "其他",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "categoryName": categoryName,
    };
  }
}
