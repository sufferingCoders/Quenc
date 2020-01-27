import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';
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
  static const String baseUrl = "192.168.1.112:8080";

  // static const String baseUrl = "192.168.1.135:8080";
  static const String apiUrl = "http://" + baseUrl;
  ChatRoom _currentRandomChatRoom;

  User get user {
    return _user;
  }

  bool get isRandomChatRoomReady {
    return _currentRandomChatRoom?.id != null &&
        _currentRandomChatRoom?.id?.isNotEmpty == true &&
        randomChatRoomChannel != null;
  }

  ChatRoom get randomChatRoom {
    return _currentRandomChatRoom;
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

      // Saving both user and token
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("user", json.encode(_user.toMap()));
      // Saving user but nogt token
      prefs.setString("email", email);
      prefs.setString("password", password);

      setUserStream();
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

  Stream<User> getUserStream() {
    if (token == null) {
      return null;
    }

    String url = "ws://" +
        baseUrl +
        "/user/subsrible"; // ipconfig can check should be IPv4 Address

    if (channel != null) {
      channel.sink.close();
    }

    channel = IOWebSocketChannel.connect(
      url,
      headers: {
        "Authorization": token,
      },
    );

    // We can get user stream from this
    return channel.stream.map((u) => User.fromMap(json.decode(u)));
  }

  /*******************************
   *             UPDATE
   *******************************/

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
              "/saved-posts/" +
              (user.savedPosts.contains(id) ? "0" : "1");
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

  Future<void> sendEnaukVerufucation() async {
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

      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }

  /*
   *  ChatRoom
   * 
   */

  IOWebSocketChannel chatRoomChannel;

  Map<String, ChatRoom> _userChatRooms;

  bool get isInit {
    return _userChatRooms != null;
  }

  Map<String, ChatRoom> get chatRooms {
    return _userChatRooms;
  }

  List<ChatRoom> get chatRoomList {
    return _userChatRooms.values.toList();
  }

  Future<ChatRoom> addChatRoom(ChatRoom inputChatRoom) async {
    try {
      final url = apiUrl + "/chat-room";
      final res = await http.post(
        url,
        headers: {
          "Authorization": UserGolangService.token,
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: json.encode(inputChatRoom.toAddingMap()),
      );

      if (res.body == null || res.body.isEmpty) {
        return null;
      }

      final resData = json.decode(res.body);

      if (res.statusCode >= 400) {
        throw HttpException(resData["err"]);
      }

      // 拿到回傳資料後 Update ID

      ChatRoom newChatRoom = ChatRoom.fromMap(resData["chatRoom"]);

      // 不做當下更新

      subscribeUserChatRoom(); // 重新Subscribe一次

      notifyListeners();

      // return chatRooms;
    } catch (e) {
      throw e;
    }
  }

  Future<Message> addMessageToChatRoom(String rid, Message inputMessage) async {
    try {
      // 先在本地進行加上, 再更改

      _userChatRooms[rid].messages.add(inputMessage);
      inputMessage.author = _user;
      notifyListeners();

      final url = apiUrl + "/chat-room/message/$rid";
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

  // User ChatRoom的資料會存在Local, 這樣Subscribe之後才會在這更改
  // setting the chatRoom Detail but not the messages, we will be adding the last message into this

  Future<void> tryInitChatRooms() async {
    if (isInit) {
      return;
    }

    await getAllUserChatRooms();
  }

  Future<List<ChatRoom>> getAllUserChatRooms() async {
    try {
      List<ChatRoom> chatRooms = [];

      final url = apiUrl + "/chat-room/rooms";
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

      List<dynamic> chatRoomsRaw = resData["chatRooms"];

      _userChatRooms = {};
      if (chatRoomsRaw != null) {
        for (var c in chatRoomsRaw) {
          ChatRoom cr = ChatRoom.fromMap(c);
          _userChatRooms[cr.id] = cr;
        }
      }

      notifyListeners();

      return chatRooms;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Message>> getMessagesForARoom(
    String roomID,
    String startID,
    int number,
  ) async {
    try {
      List<Message> messages = [];

      String url = apiUrl + "/message/$roomID?";

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

      List<dynamic> messagesRaw = resData["chatRooms"];
      if (messagesRaw != null) {
        for (var c in messagesRaw) {
          Message cr = Message.fromMap(c);
          messages.add(cr);
        }
      }

      ChatRoom retrievedRoom = _userChatRooms[roomID];
      List<String> currentMessageIds =
          retrievedRoom.messages.map((m) => m.id).toList();
      for (Message m in messages.reversed.toList()) {
        if (!currentMessageIds.contains(m.id)) {
          retrievedRoom.messages.insert(0, m);
        }
      }

      return messages;
    } catch (e) {
      throw e;
    }
  }

  Future<void> tryInitUserChatStream() async {
    if (chatRoomChannel != null) {
      return;
    }

    await subscribeUserChatRoom();
  }

  IOWebSocketChannel randomChatRoomChannel;

  Future<void> subscribeUserChatRoom() async {
    String url = "ws://" + baseUrl + "/chat-room/user/subsrible";

    if (chatRoomChannel != null) {
      await chatRoomChannel.sink.close();
    }

    chatRoomChannel = IOWebSocketChannel.connect(
      url,
      headers: {
        "Authorization": UserGolangService.token,
      },
    );

    chatRoomChannel.stream.listen((updateDetails) {
      // if the message is from the same user, then don't need to update it
      // Updating local info
      print(updateDetails); // check how this will print
      // put a switch here for handling incomming?
      // _user = User.fromMap(json.decode(u));
      notifyListeners();
    });
  }

  /**
   * Random Chat Room
   * 
   */

  // 由User決定是否連接
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

  Future<Message> addMessageToRandomChatRoom(Message inputMessage) async {
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

  Future<Message> test_addMessageToRandomChatRoom() async {
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

  Future<void> tryInitRandomChatStream() async {
    if (randomChatRoomChannel != null) {
      return;
    }

    await subscribeRandomChatRoom();
  }

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
      print(updateDetailsMap["operationType"]);

      bool isUpdate = updateDetailsMap["operationType"] == "update";
      print(isUpdate);
      if (isUpdate) {
        // 到updateDescription裡面拿取updateFields
        Map<String, dynamic> updatedMessages =
            updateDetailsMap["updateDescription"]["updatedFields"];

        updatedMessages.forEach((k, v) {
          


          Message newMessage =
              Message.fromMapAndRoom(v, _currentRandomChatRoom);

          if (newMessage?.author != _user?.id) {
            _currentRandomChatRoom.messages.add(newMessage);
          }
        });

        // 再從updateFields裡面的Key-Value Pair取出index跟Value ((或是只有Value

        // 若author是本地的User則不進行更新, 若非則

        // 用此更新本地的Message

      }

      notifyListeners();
    });
  }

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
