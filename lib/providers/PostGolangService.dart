import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';

class PostGolangService with ChangeNotifier {
  // static const String baseUrl = "192.168.1.135:8080";

  static const String baseUrl = "192.168.1.112:8080";
  static const String apiUrl = "http://" + baseUrl;

  Map<String, String> categoryIdToName = {};

  Future<void> addPostCategory(PostCategory postCategory) async {
    try {
      final url = apiUrl + "/post-category/";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(
          {"name": postCategory.categoryName},
        ),
      );

      if (res.body == null || res.body.isEmpty) {
        return;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> addPost(Post post) async {
    try {
      final url = apiUrl + "/post/";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(
          post.toAddingMap(),
        ),
      );

      if (res.body == null || res.body.isEmpty) {
        return;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  String getCategoryNameByID(String id) {
    if (categoryIdToName == null) {
      return "";
    }
    return categoryIdToName[id];
  }

  Future<List<PostCategory>> getAllPostCategories() async {
    try {
      List<PostCategory> retrievedPostCategories = [];

      final url = apiUrl + "/post-category/";
      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<dynamic> postCategoriesRaw = resData["postCategories"];
      if (postCategoriesRaw != null) {
        for (var c in postCategoriesRaw) {
          PostCategory newCat = PostCategory.fromMap(c);
          retrievedPostCategories.add(newCat);
          if (newCat != null && newCat.id != null) {
            categoryIdToName[newCat.id] = newCat.categoryName;
          }
        }
      }
      return retrievedPostCategories;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Post>> getPostForAuthor(String aid) async {
    if (aid == null) {
      return null;
    }
    try {
      List<Post> retrievedPost = [];

      final url = apiUrl + "/post/author/$aid";
      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<Map<String, dynamic>> posts = resData["posts"];

      for (var p in posts) {
        Post newPost = Post.fromMap(p);
        retrievedPost.add(newPost);
      }
      return retrievedPost;
    } catch (e) {
      throw e;
    }
  }

  // Doing this
  Future<List<Post>> getAllPosts({
    OrderByOption orderBy = OrderByOption.CreatedAt,
    int skip = 0,
    int limit = 50,
    String categoryId = "all",
  }) async {
    try {
      List<Post> retrievedPost = [];

      String url = apiUrl +
          "/post/category/${(categoryId?.isNotEmpty == true && categoryId != null) ? categoryId : "all"}?";

      if (skip != null) {
        url += "&skip=$skip";
      }

      if (limit != null) {
        url += "&limit=$limit";
      }

      switch (orderBy) {
        case OrderByOption.CreatedAt:
          break;
        case OrderByOption.LikeCount:
          url += "&sort=likecount";
          break;
        default:
          break;
      }

      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res?.body == null || res?.body?.isEmpty == true) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<dynamic> posts = resData["posts"];
      if (posts != null) {
        for (var p in posts) {
          Post newPost = Post.fromMap(p);
          retrievedPost.add(newPost);
        }
      }

      return retrievedPost;
    } catch (e) {
      throw e;
    }
  }

  Future<Post> getPostByID(String postId) async {
    Post post;
    try {
      if (postId != null && postId?.isNotEmpty == true) {
        final url = apiUrl + "/post/detail/$postId";
        final res = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "Authorization": UserGolangService.token,
          },
        );

        if (res.body == null || res.body.isEmpty) {
          return null;
        }

        final resData = json.decode(res.body);

        if (res.statusCode >= 400) {
          throw HttpException(resData["err"]);
        }

        post = Post.fromMap(resData["post"]);
      }
    } catch (e) {
      throw e;
    }
    return post;
  }

  Future<List<Post>> getSavedPosts() async {
    List<Post> retrievedPosts = [];
    try {
      final url = apiUrl + "/post/saved";
      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<Map<String, dynamic>> posts = resData["posts"];

      for (var p in posts) {
        Post newPost = Post.fromMap(p);
        retrievedPosts.add(newPost);
      }
    } catch (e) {
      throw e;
    }
    return retrievedPosts;
  }

  Future<void> updatePost(
      String postId, Map<String, dynamic> updateFields) async {
    // Remove ID field and CreatedAt field <- in the backend
    try {
      final url = apiUrl + "/post/detail/$postId";
      final res = await http.patch(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(updateFields),
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePostCategoriesById(String cid) async {
    try {
      final url = apiUrl + "/post-category/$cid";
      final res = await http.delete(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final url = apiUrl + "/post/$postId";
      final res = await http.delete(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }
}
