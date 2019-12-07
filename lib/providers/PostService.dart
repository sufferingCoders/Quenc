import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quenc/models/Post.dart';

class PostService with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  // It doesn't need the Service with WebSocket

  Future<String> addPost(Post post) async {
    var ref = await _db.collection("posts").add(post.toMap());
    // Adding to the user data
    // Adinng in the local?
    return ref.documentID;
  }

  Future<void> editPost(Post post) async {
    DocumentReference ref = _db.collection("posts").document();

    return ref.setData(
      {...(post.toMap())},
      merge: true,
    );
  }
}
