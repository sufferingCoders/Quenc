import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quenc/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  // Not storing val in this calss since its instance will not be kept


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  // FirebaseUser _fbUser;
  // User _user;

  // FirebaseUser get fbUser {
  //   return _fbUser;
  // }

  // User get user {
  //   return _user;
  // }

  /*
   * Adding Post or Comment to User
   */

  Future<void> addPostToUser(postID, userId) async {
    await _db.collection("users").document(userId).updateData({
      "posts": FieldValue.arrayUnion([postID])
    });
  }

  /*
   * Updating the user field
   */

  void updateFirebaseUserDataToDB(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  void updateCollectionUserData(String uid, Map user) async {
    DocumentReference ref = _db.collection('users').document(uid);

    return ref.setData({
      ...user,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  // Fetching the user stream
  Stream<User> userStream(FirebaseUser user) {
    print("User stream is called");
    if (user == null) return null;
    print("User stream is called and return stream");

    var userStream = _db
        .collection("users")
        .document(user.uid)
        .snapshots()
        .map((u) => User.fromMap(u.data));

    // also listen to the userStream

    // userStream.listen((u) {
    //   _user = u;
    //   notifyListeners();
    // });

    return userStream;
  }

  void addListenerToUserStream(FirebaseUser user) {
    var userStream = _db
        .collection("users")
        .document(user.uid)
        .snapshots()
        .map((u) => User.fromMap(u.data));

    // userStream.listen((u) {
    //   _user = u;
    //   notifyListeners();
    // });
  }

  /*
    Authorization Functions 
  */

  Future<FirebaseUser> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      var fbUser = (await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim()))
          .user;

      fbUser.sendEmailVerification();
      updateFirebaseUserDataToDB(fbUser);

      return fbUser;
    } catch (error) {
      print("The error is ${error.toString()}");
      return null;
    }
  }

  Future<FirebaseUser> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      var fbUser = (await _auth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim()))
          .user;

      updateFirebaseUserDataToDB(fbUser);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);
      prefs.setString("password", password);
      // Save emeail and password in prefernece
      return fbUser;
    } catch (error) {
      print("The error is ${error.toString()}");
      return null;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("email") || !prefs.containsKey("password")) {
      return false;
    }

    String email = prefs.getString("email");
    String password = prefs.getString("password");
    loginWithEmailAndPassword(email, password);
    return true;
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();

      final prefs = await SharedPreferences.getInstance();
      prefs.remove("email");
      prefs.remove("password");

      // _fbUser = null;
      // _user = null;

      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}
