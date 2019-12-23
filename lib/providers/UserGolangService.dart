import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

enum ToggleOptions {
  ChatRooms,
  Friends,
  LikePosts,
  LikeComments,
  SavedPosts,
}

class UserGolangService with ChangeNotifier {
  // No storing val in this calss since its instance will not be kept
  IOWebSocketChannel channel;
  User _user;
  static String _token;
  static const String baseUrl = "192.168.1.135:8080";
  static const String apiUrl = "http://" + baseUrl;

  User get user {
    return _user;
  }

  static String get token {
    return _token;
  }

  bool get isLogin {
    return (token != null && user != null);
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    // The urlSeg can be "login" or "signup"

    final url = apiUrl + "user/$urlSeg";

    try {
      final res = await http.post(url,
          headers: {
            // HttpHeaders.connectionHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json"
          },
          body: json.encode({
            "email": email,
            "password": password,
          }));
      final resData = json.decode(res.body);
      if (res.statusCode >= 400) {
        throw HttpException(
          resData['err'],
        );
      }

      // Adding data
      _token = resData["token"];
      _user = User.fromMap(resData["user"]);

      notifyListeners();

      // Saving both user and token
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("user", json.encode(_user.toMap()));
      // Saving user but not token
      prefs.setString("email", email);
      prefs.setString("password", password);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signupUser(String email, String password) async {
    return _authenticate(email, password, "signup");
  }

  Future<void> loginUser(String email, String password) async {
    return _authenticate(email, password, "login");
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();

    prefs.remove("email");
    prefs.remove("password");
    notifyListeners();

    // delete the data stored in the sharedPref
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("email") || !prefs.containsKey("password")) {
      return false;
    }

    String email = prefs.getString("email");
    String password = prefs.getString("password");

    _authenticate(email, password, "login");
    return true;
  }

  /*******************************
   *             GET
   *******************************/

  /// Fetching the User Stream from Firestore
  void setUserStream() async {
    String url = "ws://" +
        baseUrl +
        "/subsrible"; // ipconfig can check should be IPv4 Address

    if (channel != null) {
      await channel.sink.close();
    }
    channel = IOWebSocketChannel.connect(url);
    channel.stream.listen((u) {
      _user = User.fromMap(u);
      notifyListeners();
    });
  }

  /*******************************
   *             UPDATE
   *******************************/

  Future<void> toggoleFunction(
    String id,
    ToggleOptions toggle,
  ) async {
    try {
      String fullApi;

      switch (toggle) {
        case ToggleOptions.Friends:
          fullApi =
              apiUrl + "/friends/" + (user.friends.contains(id) ? "0" : "1");
          break;
        case ToggleOptions.ChatRooms:
          fullApi = apiUrl +
              "/chat-rooms/" +
              (user.chatRooms.contains(id) ? "0" : "1");
          break;
        case ToggleOptions.LikePosts:
          fullApi = apiUrl +
              "/like-posts/" +
              (user.likePosts.contains(id) ? "0" : "1");

          break;
        case ToggleOptions.LikeComments:
          fullApi = apiUrl +
              "/like-comments/" +
              (user.likeComments.contains(id) ? "0" : "1");

          break;
        case ToggleOptions.SavedPosts:
          fullApi = apiUrl +
              "/saved-posts/" +
              (user.savedPosts.contains(id) ? "0" : "1");

          break;
        default:
          fullApi = null;
          break;
      }
      final res = await http.post(
        fullApi,
        headers: {
          "Authorization": token,
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

  Future<void> updateUser(String id, Map<String, dynamic> updateFields) async {
    try {
      final url = apiUrl + "/detail/$id";
      final res = await http.patch(url, body: json.encode(updateFields));

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

  /// Signout the User from Firebase
  Future<String> signOut() async {
    try {
      _token = null;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      prefs.remove("email");
      prefs.remove("password");

      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}
