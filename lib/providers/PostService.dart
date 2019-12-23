import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';

class PostService with ChangeNotifier {
  /*
   *  Dont Need WebSocket For this Service
   */

  final Firestore _db = Firestore.instance;
  List<Post> _currentPosts;
  Map<String, String> categoryIdToName = {};

  /// Get All Current Posts
  List<Post> get posts {
    return _currentPosts;
  }

  /// Check if Current Post is initialised
  bool get postIsInit {
    return _currentPosts != null;
  }

  /*******************************
   *             ADD
   *******************************/

  /// Add a post category to firestore
  Future<String> addPostCategory(PostCategory postCategory) async {
    var ref = _db.collection("postCategory").document();
    postCategory.id = ref.documentID;
    await ref.setData(
      postCategory.toMap(),
    );

    notifyListeners();
    return ref.documentID;
  }

  /// Add a post to Firestore
  Future<String> addPost(Post post) async {
    var ref = _db.collection("posts").document();
    post.id = ref.documentID;
    await ref.setData(post.toMap());
    return ref.documentID;
  }

  /*******************************
   *             GET
   *******************************/

  String getCategoryNameByID(String id) {
    if (categoryIdToName == null) {
      return "";
    }
    return categoryIdToName[id];
  }

  /// Retrieve All Post Categories
  Future<List<PostCategory>> getAllPostCategories() async {
    List<PostCategory> retrievedPostCategories = [];
    var docs = await _db.collection("postCategory").getDocuments();

    for (var d in docs.documents) {
      if (d.exists) {
        var newCat = PostCategory.fromMap(d.data);
        retrievedPostCategories.add(newCat);
        if (newCat != null && newCat.id != null) {
          categoryIdToName[newCat.id] = newCat.categoryName;
        }
      }
    }

    notifyListeners();

    return retrievedPostCategories;
  }

  /// Get all Posts made by the User
  Future<List<Post>> getPostForUser(String userId) async {
    List<Post> retrievedPost = [];
    var ref = await _db
        .collection("posts")
        .where("author", isEqualTo: userId)
        .getDocuments();
    for (var d in ref.documents) {
      retrievedPost.add(Post.fromMap(d.data));
    }
    return retrievedPost;
  }

  /// Initialise Current Posts
  Future<void> initialisePosts() async {
    _currentPosts = [];

    QuerySnapshot posts =
        await _db.collection("posts").orderBy("createdAt").getDocuments();

    if (posts.documents.length > 0) {
      posts.documents.forEach((d) {
        Map<String, dynamic> retrievedPost = d.data;
        retrievedPost["id"] = d.documentID;
        Post postObj = Post.fromMap(retrievedPost);
        _currentPosts.add(postObj);
      });
      notifyListeners();
    }
  }

  Future<RetrievedPostsAndLastSnapshot> getAllPosts({
    PostOrderByOption orderBy = PostOrderByOption.CreatedAt,
    DocumentSnapshot startAfter,
    int pageSize = 50,
    String categoryId,
  }) async {
    List<Post> retrievedPosts = [];

    CollectionReference coRef = _db.collection("posts");
    Query ref;
    if (categoryId != null) {
      if (ref == null) {
        ref = coRef.where("category", isEqualTo: categoryId);
      } else {
        ref = ref.where("category", isEqualTo: categoryId);
      }
    }

    switch (orderBy) {
      case PostOrderByOption.CreatedAt:
        if (ref == null) {
          ref = coRef.orderBy("createdAt", descending: true);
        } else {
          ref = ref.orderBy("createdAt", descending: true);
        }
        break;
      case PostOrderByOption.LikeCount:
        if (ref == null) {
          ref = coRef
              .where("createdAt",
                  isGreaterThanOrEqualTo:
                      DateTime.now().subtract(Duration(days: 15)))
              .orderBy("createdAt", descending: true);
          //
        } else {
          ref = ref
              .where("createdAt",
                  isGreaterThanOrEqualTo:
                      DateTime.now().subtract(Duration(days: 15)))
              .orderBy("createdAt", descending: true);

          //
        }
        break;
      default:
        if (ref == null) {
          ref = coRef.orderBy("createdAt");
        } else {
          ref = ref.orderBy("createdAt");
        }
    }

    if (startAfter != null) {
      if (ref == null) {
        ref = coRef.startAfterDocument(startAfter);
      } else {
        ref = ref.startAfterDocument(startAfter);
      }
    }

    if (pageSize != null) {
      if (ref == null) {
        ref = coRef.limit(pageSize);
      } else {
        ref = ref.limit(pageSize);
      }
    }

    var docs = await ref.getDocuments();
    // .orderBy("createdAt")
    // .getDocuments();
    if (docs.documents.length > 0) {
      docs.documents.forEach((d) {
        retrievedPosts.add(Post.fromMap(d.data));
      });

      if (orderBy == PostOrderByOption.LikeCount) {
        retrievedPosts.sort((a, b) {
          return b.likeCount.compareTo(a.likeCount);
        });
      }

      RetrievedPostsAndLastSnapshot postAndSnapshot =
          RetrievedPostsAndLastSnapshot(
        retrievedPosts: retrievedPosts,
        lastSnapshot: docs.documents[docs.documents.length - 1],
      );

      return postAndSnapshot;
    }
  }

  /// Get Post by its ID
  Future<Post> getPostByID(String postId) async {
    Post post;
    try {
      if (postId != null && postId.isNotEmpty) {
        var postRef = await _db.collection("posts").document(postId).get();
        if (postRef.exists) {
          post = Post.fromMap(postRef.data);
          return post;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Get posts by an Array of IDs
  Future<List<Post>> getMultiplePostsByIds(List<String> ids) async {
    List<Post> retrievedPosts = [];
    var docs =
        await _db.collection("posts").where("id", whereIn: ids).getDocuments();
    for (var d in docs.documents) {
      retrievedPosts.add(Post.fromMap(d.data));
    }
    return retrievedPosts;
  }

  /// Get All the Posts
  Future<void> getPosts() async {
    QuerySnapshot posts;
    try {
      if (_currentPosts.isEmpty || _currentPosts.length == 0) {
        // This is the initialising
        posts =
            await _db.collection("posts").orderBy("createdAt").getDocuments();
      } else {
        // We already have the posts
        posts = await _db
            .collection("posts")
            .orderBy("createdAt")
            .startAfter([_currentPosts[-1].toMap()]).getDocuments();
      }

      if (posts != null && posts.documents.length > 0) {
        posts.documents.forEach((d) {
          Map<String, dynamic> retrievedPost = d.data;
          retrievedPost["id"] = d.documentID;
          Post postObj = Post.fromMap(retrievedPost);
          _currentPosts.add(postObj);
        });
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /*******************************
   *             UPDATE
   *******************************/

  /// Edit a post
  Future<void> editPost(Post post) async {
    DocumentReference ref = _db.collection("posts").document(post.id);

    return ref.setData(
      {...(post.toMapWithoutId())},
      merge: true,
    );
  }

  /// Try to initialise the currentPosts
  Future<void> tryInitPosts() async {
    if (!postIsInit) {
      initialisePosts();
    }
  }

  /// Update the Post by ID and Update Fields
  Future<void> updatePost(
      String postId, Map<String, dynamic> updateFields) async {
    DocumentReference ref = _db.collection("posts").document(postId);

    return ref.setData(updateFields, merge: true);
  }

  /*******************************
   *             DELETE
   *******************************/

  /// Delete a Category by its ID
  Future<bool> deletePostCategoriesById(String cid) async {
    try {
      await _db.collection("postCategory").document(cid).delete();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete the Post by its ID
  Future<bool> deletePost(String postId) async {
    try {
      await _db.collection("posts").document(postId).delete();
      bool ok = await deleteCommentsForPost(postId);
      if (!ok) {
        return false;
      }
      return true;
    } catch (e) {
      print("Error: ${e.toString()}");
      return false;
    }
  }

  /// Delete all the comments for the post by post's id
  Future<bool> deleteCommentsForPost(String postId) async {
    // doing it in the backend, if I delete the post, the backend will delete comment as well
    try {
      var docs = await _db
          .collection("comments")
          .where("belongPost", isEqualTo: postId)
          .getDocuments();
      var batch = _db.batch();

      for (var d in docs.documents) {
        batch.delete(d.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print("Delete Comments for Post Error : ${e.toString()}");
      return false;
    }
  }
}

class RetrievedPostsAndLastSnapshot {
  List<Post> retrievedPosts;
  DocumentSnapshot lastSnapshot;

  RetrievedPostsAndLastSnapshot({
    this.retrievedPosts,
    this.lastSnapshot,
  });
}

enum PostOrderByOption {
  CreatedAt,
  LikeCount,
}
