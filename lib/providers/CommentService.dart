// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:quenc/models/Comment.dart';

// enum CommentOrderByOptions {
//   ByCreatedAt,
//   ByLikeCount,
// }

// class CommentService with ChangeNotifier {
//   final Firestore _db = Firestore.instance;
//   final int _pageSize = 50;

//   /*******************************
//    *             GET
//    *******************************/

//   /// Get the top.N liked comments for a certain post
//   Future<List<Comment>> getTopLikedCommentsForPost(
//       String postId, int top) async {
//     List<Comment> retrivedComments = [];
//     var ref = _db
//         .collection("comments")
//         .where("belongPost", isEqualTo: postId)
//         .orderBy("likeCount", descending: true)
//         .limit(top);
//     var docs = await ref.getDocuments();

//     for (DocumentSnapshot d in docs.documents) {
//       retrivedComments.add(Comment.fromMap(d.data));
//     }

//     return retrivedComments;
//   }

//   ///  Get a comment by comment ID
//   Future<Comment> getCommentById(String id) async {
//     var doc = await _db.collection("comments").document(id).get();
//     if (!doc.exists) {
//       return null;
//     }
//     return Comment.fromMap(doc.data);
//   }

//   /// Get a comments for a post by post ID
//   Future<List<Comment>> getCommentForPost(
//     String postId, {
//     CommentOrderByOptions orderBy,
//   }) async {
//     List<Comment> retrivedComments = [];
//     if (orderBy == CommentOrderByOptions.ByCreatedAt) {}

//     var ref = _db.collection("comments").where("belongPost", isEqualTo: postId);

//     switch (orderBy) {
//       case CommentOrderByOptions.ByCreatedAt:
//         ref.orderBy("createdAt");
//         break;
//       case CommentOrderByOptions.ByLikeCount:
//         ref.orderBy("likeCount");
//         break;
//       default:
//         break;
//     }

//     var docs = await ref.getDocuments();

//     for (DocumentSnapshot d in docs.documents) {
//       retrivedComments.add(Comment.fromMap(d.data));
//     }

//     return retrivedComments;
//   }

//   /*******************************
//    *             ADD
//    *******************************/

//   /// Add comment to firestore database
//   Future<String> addComment(Comment comment) async {
//     var ref = _db.collection("comments").document();
//     comment.id = ref.documentID;
//     await ref.setData(comment.toMap());

//     return ref.documentID;
//   }

//   /*******************************
//    *             DELETE
//    *******************************/

//   /// Delete a comment by comment ID
//   Future<bool> deleteComment(String commentId) async {
//     try {
//       await _db.collection("comments").document(commentId).delete();
//       return true;
//     } catch (e) {
//       print("Comment deleting error:${e.toString()}");
//       return false;
//     }
//   }

//   /*******************************
//    *             UPDATE
//    *******************************/

//   /// Update a comment by comment ID
//   Future<String> updateComment(
//       String commentId, Map<String, dynamic> updateFields) {
//     DocumentReference ref = _db.collection("comments").document(commentId);
//     return ref.setData(updateFields, merge: true);
//   }
// }
