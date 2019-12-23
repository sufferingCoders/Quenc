// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:quenc/models/User.dart';
// import 'package:quenc/utils/index.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserService {
//   // No storing val in this calss since its instance will not be kept

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Firestore _db = Firestore.instance;

//   /*******************************
//    *             ADD
//    *******************************/

//   /// Add a Post to user-owing array
//   Future<void> addPostToUser(postID, userId) async {
//     await _db.collection("users").document(userId).updateData({
//       "posts": FieldValue.arrayUnion([postID])
//     });
//   }

//   /*******************************
//    *             GET
//    *******************************/

//   /// Fetching the User Stream from Firestore
//   Stream<User> userStream(FirebaseUser user) {
//     if (user == null) return null;

//     var userStream = _db
//         .collection("users")
//         .document(user.uid)
//         .snapshots()
//         .map((u) => User.fromMap(u.data));

//     return userStream;
//   }

//   /*******************************
//    *             UPDATE
//    *******************************/

//   /// Toggle like for a comment
//   Future<int> toggleCommentLike(String commentId, User user) async {
//     if (user.likeComments.contains(commentId)) {
//       await _db.collection("users").document(user.id).updateData({
//         "likeComments": FieldValue.arrayRemove([commentId]),
//       });

//       await _db.collection("comments").document(commentId).updateData({
//         "likeCount": FieldValue.increment(-1),
//       });
//       return -1;
//     } else {
//       await _db.collection("users").document(user.id).updateData({
//         "likeComments": FieldValue.arrayUnion([commentId]),
//       });

//       await _db.collection("comments").document(commentId).updateData({
//         "likeCount": FieldValue.increment(1),
//       });
//       return 1;
//     }
//   }

//   /// Toggle like for a post
//   Future<int> togglePostLike(String postId, User user) async {
//     if (user.likePosts.contains(postId)) {
//       // Dislike the post
//       await _db.collection("users").document(user.id).updateData({
//         "likePosts": FieldValue.arrayRemove([postId]),
//       });

//       await _db.collection("posts").document(postId).updateData(
//         {
//           "likeCount": FieldValue.increment(-1),
//         },
//       );

//       return -1;
//     } else {
//       await _db.collection("users").document(user.id).updateData({
//         "likePosts": FieldValue.arrayUnion([postId]),
//       });

//       await _db.collection("posts").document(postId).updateData(
//         {
//           "likeCount": FieldValue.increment(1),
//         },
//       );

//       return 1;
//     }
//   }

//   /// Toggle archive for a post
//   Future<int> togglePostArchive(String postId, User user) async {
//     if (user.savedPosts.contains(postId)) {
//       // Dislike the post
//       await _db.collection("users").document(user.id).updateData({
//         "archivePosts": FieldValue.arrayRemove([postId]),
//       });

//       await _db.collection("posts").document(postId).updateData(
//         {
//           "likeCount": FieldValue.increment(-1),
//         },
//       );
//       return -1;
//     } else {
//       await _db.collection("users").document(user.id).updateData({
//         "archivePosts": FieldValue.arrayUnion([postId]),
//       });

//       await _db.collection("posts").document(postId).updateData(
//         {
//           "likeCount": FieldValue.increment(1),
//         },
//       );
//       return 1;
//     }
//   }

//   /// Passing the Firebase User Data to Firestore
//   void updateFirebaseUserDataToDB(FirebaseUser user) async {
//     DocumentReference ref = _db.collection('users').document(user.uid);

//     return ref.setData({
//       'id': user.uid,
//       'email': user.email,
//       'photoURL': user.photoUrl,
//       'domain': Utils.getDomainFromEmail(user.email),
//       'lastSeen': DateTime.now(),
//     }, merge: true);
//   }

//   /// Update the User Data in Firestore by its ID and User Map (Merge = true)
//   void updateCollectionUserData(String id, Map user) async {
//     DocumentReference ref = _db.collection('users').document(id);

//     return ref.setData({
//       ...user,
//       'lastSeen': DateTime.now(),
//     }, merge: true);
//   }

//   /*******************************
//    *             DELETE
//    *******************************/

//   /*******************************
//    *        AUTHORIZATION
//    *******************************/

//   /// Signup User to Firebase By Email and Password
//   Future<FirebaseUser> signupWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       var fbUser = (await _auth.createUserWithEmailAndPassword(
//               email: email.trim(), password: password.trim()))
//           .user;

//       fbUser.sendEmailVerification();
//       updateFirebaseUserDataToDB(fbUser);

//       return fbUser;
//     } catch (error) {
//       print("The error is ${error.toString()}");
//       return null;
//     }
//   }

//   /// Login User to Firebase by Email and Password
//   Future<FirebaseUser> loginWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       var fbUser = (await _auth.signInWithEmailAndPassword(
//               email: email.trim(), password: password.trim()))
//           .user;

//       updateFirebaseUserDataToDB(fbUser);
//       final prefs = await SharedPreferences.getInstance();
//       prefs.setString("email", email);
//       prefs.setString("password", password);
//       // Save emeail and password in prefernece
//       return fbUser;
//     } catch (error) {
//       print("The error is ${error.toString()}");
//       return null;
//     }
//   }

//   /// Try to Login by the Email and Password saved in the SharedPreference
//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey("email") || !prefs.containsKey("password")) {
//       return false;
//     }

//     String email = prefs.getString("email");
//     String password = prefs.getString("password");
//     loginWithEmailAndPassword(email, password);
//     return true;
//   }

//   /// Signout the User from Firebase
//   Future<String> signOut() async {
//     try {
//       await _auth.signOut();

//       final prefs = await SharedPreferences.getInstance();
//       prefs.remove("email");
//       prefs.remove("password");

//       return 'SignOut';
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }
