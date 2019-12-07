import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quenc/models/Post.dart';

class PostService {
  final Firestore _db = Firestore.instance;

  // It doesn't need the Service with WebSocket

  Future<String> addPost(Post post) async {
    var ref = await _db.collection("posts").add(post.toMap());
    return ref.documentID;
  }
}
