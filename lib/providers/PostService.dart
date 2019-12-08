import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quenc/models/Post.dart';

class PostService with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  final int _pageSize = 50;
  List<Post> _currentPosts = [];

  List<Post> get posts {
    return _currentPosts;
  }

  // It doesn't need the Service with WebSocket

  Future<String> addPost(Post post) async {
    var ref = await _db.collection("posts").add(post.toMapWithoutId());
    // Adding to the user data
    // Adinng in the local?
    return ref.documentID;
  }

  Future<void> editPost(Post post) async {
    DocumentReference ref = _db.collection("posts").document(post.id);

    return ref.setData(
      {...(post.toMapWithoutId())},
      merge: true,
    );
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
