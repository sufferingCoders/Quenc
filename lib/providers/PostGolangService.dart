import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/providers/UserGolangService.dart';

class PostGolangService with ChangeNotifier {
  static const String baseUrl = "192.168.1.135:8080";
  static const String apiUrl = "http://" + baseUrl;

  Map<String, String> categoryIdToName = {};

  Future<void> addPostCategory(PostCategory postCategory) async {
    try {
      final url = apiUrl + "/post-category";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(
          postCategory.toMap(),
        ),
      );

      if (res.body == res.body.isEmpty) {
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
      final url = apiUrl + "/post";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(
          post.toMap(),
        ),
      );

      if (res.body == res.body.isEmpty) {
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

      final url = apiUrl + "/post-category";
      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
      );

      if (res.body == res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<Map<String, dynamic>> postCategories_raw = resData["postCategories"];

      for (var c in postCategories_raw) {
        PostCategory newCat = PostCategory.fromMap(c);
        retrievedPostCategories.add(newCat);
        if (newCat != null && newCat.id != null) {
          categoryIdToName[newCat.id] = newCat.categoryName;
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

      if (res.body == res.body.isEmpty) {
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
  Future<List<Post>> getAllPosts(String aid) async {
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

      if (res.body == res.body.isEmpty) {
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
}
