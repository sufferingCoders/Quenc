import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/Comment.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';

class CommentGolangService with ChangeNotifier {
  static const String baseUrl = UserGolangService.baseUrl;

  static const String apiUrl = "http://" + baseUrl;

  /**
   * Create 
   */

  /// Add the Comment to backend
  Future<void> addComment(Comment comment) async {
    try {
      final url = apiUrl + "/comment/";
      final res = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(
          comment.toAddingMap(),
        ),
      );

      if (res.body == null || res.body.isEmpty) {
        return;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /**
   * Update
   */

  /// Update a comment by its ID and updateFields
  Future<void> updateComment(
      String commentId, Map<String, dynamic> updateFields) async {
    try {
      final url = apiUrl + "/comment/detail/$commentId";
      final res = await http.patch(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
        body: json.encode(updateFields),
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

  /**
   * Delete
   */

  ///  Delete a comment by its ID
  Future<void> deleteComment(String commentId) async {
    try {
      final url = apiUrl + "/comment/$commentId";
      final res = await http.delete(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": UserGolangService.token,
        },
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

  /**
   * Retrieve
   */

  /// Showing Top-Liked Comments
  Future<List<Comment>> getTopLikedCommentsForPost(
      String postId, int top) async {
    List<Comment> retrivedComments = await getCommentForPost(
        pid: postId, limit: top, skip: 0, orderBy: OrderByOption.LikeCount);
    return retrivedComments;
  }

  /// Get certain comment by its ID
  Future<Comment> getCommentById(String id) async {
    Comment comment;
    try {
      final url = apiUrl + "/comment/detail/$id";
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

      comment = Comment.fromMap(resData["comment"]);
    } catch (e) {
      throw e;
    }
    return comment;
  }

  /// Get comments for post
  Future<List<Comment>> getCommentForPost({
    String pid,
    OrderByOption orderBy = OrderByOption.CreatedAt,
    int skip = 0,
    int limit = 50,
  }) async {
    List<Comment> retrivedComments = [];

    try {
      String url = apiUrl + "/comment/post/$pid?";

      if (skip != null) {
        url += "&skip=$skip";
      }

      if (limit != null) {
        url += "&limit=$limit";
      }

      if (orderBy == OrderByOption.LikeCount) {
        url += "&sort=likeCount";
      }

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

      List<dynamic> comments = resData["comments"];
      if (comments != null) {
        for (var c in comments) {
          Comment newComment = Comment.fromMap(c);
          retrivedComments.add(newComment);
        }
      }

      return retrivedComments;
    } catch (e) {
      throw e;
    }
  }
}

/// The Option for sorting the comment
enum CommentOrderByOption {
  LikeCount,
  CreatedAt,
}
