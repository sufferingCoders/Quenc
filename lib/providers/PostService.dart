import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/PostCategory.dart';

class PostService with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _pageSize = 50;
  List<Post> _currentPosts;

  List<Post> get posts {
    return _currentPosts;
  }

  bool get postIsInit {
    return _currentPosts != null;
  }

  // It doesn't need the Service with WebSocket

  Future<bool> deletePostCategoriesById(String cid) async {
    try {
      await _db.collection("postCategory").document(cid).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<PostCategory>> getAllPostCategories() async {
    List<PostCategory> retrievedPostCategories = [];
    var docs = await _db.collection("postCategory").getDocuments();

    for (var d in docs.documents) {
      if (d.exists) {
        retrievedPostCategories.add(PostCategory.fromMap(d.data));
      }
    }

    return retrievedPostCategories;
  }

  Future<String> addPostCategory(PostCategory postCategory) async {
    var ref = _db.collection("postCategory").document();
    postCategory.id = ref.documentID;
    await ref.setData(
      postCategory.toMap(),
    );

    notifyListeners();
    return ref.documentID;
  }

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

  Future<String> addPost(Post post) async {
    var ref = _db.collection("posts").document();
    post.id = ref.documentID;
    await ref.setData(post.toMap());
    // var ref = await _db.collection("posts").add(post.toMapWithoutId());
    // Adding to the user data
    // Adinng in the local?
    // await updatePost(ref.documentID, {"id": ref.documentID});

    return ref.documentID;
  }

  Future<void> editPost(Post post) async {
    DocumentReference ref = _db.collection("posts").document(post.id);

    return ref.setData(
      {...(post.toMapWithoutId())},
      merge: true,
    );
  }

  Future<void> tryInitPosts() async {
    if (!postIsInit) {
      initialisePosts();
    }
  }

  Future<void> initialisePosts() async {
    _currentPosts = [];

    QuerySnapshot posts = await _db
        .collection("posts")
        .orderBy("createdAt")
        .limit(_pageSize)
        .getDocuments();

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
  }

  Future<List<Post>> getMultiplePostsByIds(List<String> ids) async {
    List<Post> retrievedPosts = [];
    var docs =
        await _db.collection("posts").where("id", whereIn: ids).getDocuments();
    for (var d in docs.documents) {
      retrievedPosts.add(Post.fromMap(d.data));
    }
    return retrievedPosts;
  }

  Future<void> updatePost(
      String postId, Map<String, dynamic> updateFields) async {
    DocumentReference ref = _db.collection("posts").document(postId);

    return ref.setData(updateFields, merge: true);
  }

  // Future<void> toggleLike(Post post, String uid) async {
  //   if (post.likeBy.contains(uid)) {
  //     // Dislike the post
  //     await _db.collection("posts").document(post.id).updateData({
  //       "likedBy": FieldValue.arrayRemove([uid]),
  //     });
  //   } else {
  //     await _db.collection("posts").document(post.id).updateData({
  //       "likedBy": FieldValue.arrayRemove([uid]),
  //     });
  //   }
  // }

  Future<void> getPosts() async {
    QuerySnapshot posts;
    try {
      if (_currentPosts.isEmpty || _currentPosts.length == 0) {
        // This is the initialising
        posts = await _db
            .collection("posts")
            .orderBy("createdAt")
            .limit(_pageSize)
            .getDocuments();
      } else {
        // We already have the posts
        posts = await _db
            .collection("posts")
            .orderBy("createdAt")
            .startAfter([_currentPosts[-1].toMap()])
            .limit(_pageSize)
            .getDocuments();
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
}
