class PostCategory {
  // Category for Post

  String id;
  String categoryName;

  PostCategory({
    this.categoryName,
    this.id,
  });

  factory PostCategory.fromMap(Map data) {
    return PostCategory(
      id: data["id"] ?? "",
      categoryName: data["categoryName"] ?? "其他",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoryName": categoryName,
    };
  }
}
