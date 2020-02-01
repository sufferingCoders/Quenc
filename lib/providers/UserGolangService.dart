import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

/// Toggle the fields in the backend
enum ToggleOptions {
  ChatRooms,
  Friends,
  LikePosts,
  LikeComments,
  SavedPosts,
  BlockPost,
  BlockUser,
}

class UserGolangService with ChangeNotifier {
  static String _token;

  IOWebSocketChannel randomChatRoomChannel;
  IOWebSocketChannel channel;
  User _user;
  ChatRoom _currentRandomChatRoom;

  static const String baseUrl = "quenc-hlc.appspot.com";
  // static const String baseUrl = "192.168.1.112:8080"; // mac
  // static const String baseUrl = "192.168.1.135:8080";// windows
  static const String apiUrl = "http://" + baseUrl;

  /// get the current user
  User get user {
    return _user;
  }

  /// check if the random chat room is ready
  bool get isRandomChatRoomReady {
    return _currentRandomChatRoom?.id != null &&
        _currentRandomChatRoom?.id?.isNotEmpty == true &&
        randomChatRoomChannel != null;
  }

  /// get current random chat room
  ChatRoom get randomChatRoom {
    return _currentRandomChatRoom;
  }

  /// get the authorization backend
  static String get token {
    return _token;
  }

  /// check if the user is logged in
  bool get isLogin {
    return (token != null && user != null);
  }

  /// authenticate process, sending to backend
  Future<void> _authenticate(
    String email,
    String password,
    String urlSeg, // urlSeg can be "signup" or "login"
  ) async {
    final url = apiUrl + "/user/$urlSeg";

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
          resData['err'].toString(),
        );
      }

      // Adding data
      _token = resData["token"];
      _user = User.fromMap(resData["user"]);

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      // Saving user but not token
      prefs.setString("email", email);
      prefs.setString("password", password);

      setUserStream();
    } catch (error) {
      throw error;
    }
  }

  /// signup user
  Future<void> signupUser(String email, String password) async {
    return _authenticate(email, password, "signup");
  }

  /// login user
  Future<void> loginUser(String email, String password) async {
    return _authenticate(email, password, "login");
  }

  /// logout user
  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();

    // delete the data stored in the sharedPref
    prefs.remove("email");
    prefs.remove("password");
    notifyListeners();
  }

  /// try login if the user is not logged in
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("email") || !prefs.containsKey("password")) {
      return false;
    }

    String email = prefs.getString("email");
    String password = prefs.getString("password");

    await _authenticate(email, password, "login");
    return true;
  }

  /*******************************
   *             GET
   *******************************/

  /// Fetching the User Stream from Firestore
  void setUserStream() async {
    String url = "ws://" +
        baseUrl +
        "/user/subsrible"; // ipconfig can check should be IPv4 Address

    if (channel != null) {
      await channel.sink.close();
    }
    channel = IOWebSocketChannel.connect(
      url,
      headers: {
        "Authorization": token,
      },
    );

    // We can get user stream from this
    // channel.stream.map((u) => User.fromMap(json.decode(u)));

    channel.stream.listen((u) {
      _user = User.fromMap(json.decode(u));
      notifyListeners();
    });
  }

  /*******************************
   *             UPDATE
   *******************************/

  /// toggle the fields in the backend
  Future<void> toggoleFunction({
    String id,
    ToggleOptions toggle,
    bool condition = false,
  }) async {
    try {
      String fullApi;

      switch (toggle) {
        case ToggleOptions.Friends:
          fullApi = apiUrl +
              "/user/friends/$id/" +
              (user.friends.contains(id) ? "0" : "1");
          break;
        case ToggleOptions.ChatRooms:
          fullApi = apiUrl +
              "/user/chat-rooms/$id/" +
              (user.chatRooms.contains(id) ? "0" : "1");
          break;
        case ToggleOptions.LikePosts:
          fullApi =
              apiUrl + "/post/like/$id?condition=" + (condition ? "1" : "0");

          break;
        case ToggleOptions.LikeComments:
          fullApi =
              apiUrl + "/comment/like/$id?condition=" + (condition ? "1" : "0");
          break;
        case ToggleOptions.SavedPosts:
          fullApi = apiUrl +
              "/user/saved-posts/$id/" +
              (user.savedPosts.contains(id) ? "0" : "1");
          break;
        case ToggleOptions.BlockPost:
          fullApi = apiUrl + "/user/block-post/$id/1";
          break;

        case ToggleOptions.BlockUser:
          fullApi = apiUrl + "/user/block-user/$id/1";
          break;
          
        default:
          fullApi = null;
          break;
      }
      final res = await http.patch(
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

  /// Send verification email to the user
  Future<void> sendingEmailVerification() async {
    try {
      final url = apiUrl + "/user/send-verification-email";
      final res = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Authorization": token,
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }
    } catch (e) {
      throw e;
    }
  }

  /// update the user by its id and updateFields
  Future<void> updateUser(String id, Map<String, dynamic> updateFields) async {
    try {
      final url = apiUrl + "/user/detail/$id";
      final res = await http.patch(
        url,
        headers: {
          "Authorization": token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(updateFields, toEncodable: Utils.jsonEncodable),
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

  /// Signout the User from Firebase
  Future<String> signOut() async {
    try {
      _token = null;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      prefs.remove("email");
      prefs.remove("password");
      notifyListeners();

      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }

  /**
   * Random Chat Room
   */

  /// try initialise random chatromm for the user
  Future<bool> tryInitialiseRandomChatRoom() async {
    // 2種 fields 決定 狀態 1. user.randomChatRoom 2. _currentRandomChatRoom

    if (randomChatRoom != null) {
      return true;
    }
    _currentRandomChatRoom = ChatRoom();
    bool joinSuccess = await initialiseRandomChatRoom();
    if (joinSuccess == true) {
      await tryInitRandomChatStream();
    }

    return joinSuccess;
  }

  /// force initialise the chatRoom
  Future<bool> initialiseRandomChatRoom() async {
    bool joinSuccess;
    if (user.randomChatRoom != null) {
      joinSuccess = true;
    } else {
      joinSuccess = await joinRandomChatRoom();
    }

    if (joinSuccess == true) {
      await getRandomChatRoomDetail(); // this will set the random chat in local
    }

    return joinSuccess;
  }

  /// join a random chatroom, sending a request to backend and it will assign the user to a chat room
  Future<bool> joinRandomChatRoom() async {
    try {
      final url = apiUrl + "/chat-room/random/connect";
      final res = await http.post(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return false;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        if (res.statusCode == 404) {
          return null;
        }
        throw HttpException(resData["err"]);
      }

      // 拿到回傳資料後 Update ID

      // String roomID = resData["roomID"];
      return true;

      // return chatRooms;
    } catch (e) {
      return false;
    }
  }

  /// Add the message to current random chat room
  Future<void> addMessageToRandomChatRoom(Message inputMessage) async {
    try {
      // 先在本地進行加上, 再更改
      _currentRandomChatRoom.messages.add(inputMessage);
      inputMessage.author = _user;
      notifyListeners();

      final url = apiUrl + "/chat-room/message/${_currentRandomChatRoom.id}";
      final res = await http.post(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(inputMessage.toAddingMap()),
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      // 拿到回傳資料後 Update ID

      Message newMessage = Message.fromMap(resData["message"]);
      newMessage.author = _user;

      inputMessage.replaceByAnother(newMessage); // 看看指針會不會變

      notifyListeners();

      // return chatRooms;
    } catch (e) {
      throw e;
    }
  }

  /// sending message to random chat room
  Future<void> test_addMessageToRandomChatRoom() async {
    try {
      // 先在本地進行加上, 再更改

      final url = apiUrl + "/chat-room/test/message";
      final res = await http.post(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      // return chatRooms;
    } catch (e) {
      throw e;
    }
  }

  /// get the user's random chat room detail
  Future<void> getRandomChatRoomDetail() async {
    try {
      final url = apiUrl + "/chat-room/random/room";
      final res = await http.get(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      if (resData["randomChatRoom"] != null) {
        _currentRandomChatRoom = ChatRoom.fromMap(resData["randomChatRoom"]);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  /// get number of the meesaages from current random chat room
  Future<List<Message>> getMessagesForRandomChatRoom(
    String startID,
    int number,
  ) async {
    try {
      List<Message> messages = [];

      String url = apiUrl + "/chat-room/random/message?";

      if (startID != null && startID.isNotEmpty) {
        url += "&sid=$startID";
      }

      if (number != null) {
        url += "&num=$number";
      }

      final res = await http.get(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      List<dynamic> messagesRaw = resData["messages"];
      if (messagesRaw != null) {
        for (var c in messagesRaw) {
          Message cr = Message.fromMapAndRoom(c, _currentRandomChatRoom);
          messages.add(cr);
        }
      }

      List<String> currentMessageIds =
          _currentRandomChatRoom.messages.map((m) => m.id).toList();

      for (Message m in messages.reversed.toList()) {
        bool alreadyHave = currentMessageIds.contains(m.id);
        print(alreadyHave);
        if (!alreadyHave) {
          _currentRandomChatRoom.messages.insert(0, m);
        }
      }

      notifyListeners();

      return messages;
    } catch (e) {
      throw e;
    }
  }

  /// try to initialise the websocket stream
  Future<void> tryInitRandomChatStream() async {
    if (randomChatRoomChannel != null) {
      return;
    }

    await subscribeRandomChatRoom();
  }

  /// set the random chat room stream
  Future<void> subscribeRandomChatRoom() async {
    String url = "ws://" + baseUrl + "/chat-room/random/subscribe";

    if (randomChatRoomChannel != null) {
      await randomChatRoomChannel.sink.close();
    }

    randomChatRoomChannel = IOWebSocketChannel.connect(
      url,
      headers: {
        "Authorization": UserGolangService.token,
      },
    );

    randomChatRoomChannel.stream.listen((updateDetails) {
      // if the message is from the same user, then don't need to update it
      // Updating local info
      print(updateDetails); // check how this will print
      // put a switch here for handling incomming?
      // _user = User.fromMap(json.decode(u));
      // 1. 先Check更新的類型

      var updateDetailsMap = json.decode(updateDetails);

      //  要先Decode以後才能當map用不然是String
      // print(updateDetailsMap["operationType"]);

      bool isUpdate = updateDetailsMap["operationType"] == "update";
      // print(isUpdate);
      if (isUpdate) {
        // 到updateDescription裡面拿取updateFields
        Map<String, dynamic> updatedMessages =
            updateDetailsMap["updateDescription"]["updatedFields"];

        updatedMessages.forEach((k, v) {
          if (k.contains("messages")) {
            Message newMessage =
                Message.fromMapAndRoom(v, _currentRandomChatRoom);

            if (newMessage?.author?.id != _user?.id) {
              _currentRandomChatRoom.messages.add(newMessage);
            }
          }
        });

        // 再從updateFields裡面的Key-Value Pair取出index跟Value ((或是只有Value

        // ��author是本地的User則不進行更新, 若非則

        // 用此更新本地的Message

      }
      notifyListeners();
    });
  }

  /// Leave current random chat room
  Future<void> leaveRandomChatRoom() async {
    try {
      final url = apiUrl + "/chat-room/random";
      final res = await http.delete(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      _currentRandomChatRoom = null;

      // user 則會經由WebSocket的方式更新

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
