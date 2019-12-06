import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quenc/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

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

  Stream<User> userStream(FirebaseUser user) {
    print("User stream is called");
    if (user == null) return null;
    print("User stream is called and return stream");

    return _db
        .collection("users")
        .document(user.uid)
        .snapshots()
        .map((u) => User.fromMap(u.data));
  }

  /*
    Authorization Functions 
  */

  Future<FirebaseUser> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      user.sendEmailVerification();
      updateFirebaseUserDataToDB(user);

      return user;
    } catch (error) {
      print("The error is ${error.toString()}");
      return null;
    }
  }

  Future<FirebaseUser> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      updateFirebaseUserDataToDB(user);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email", json.encode(email));
      prefs.setString("password", password);
      // Save emeail and password in prefernece
      return user;
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
}
