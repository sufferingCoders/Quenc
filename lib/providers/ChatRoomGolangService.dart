import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:web_socket_channel/io.dart';

class ChatRoomGolangService with ChangeNotifier {
  static const String baseUrl = "192.168.1.135:8080";
  static const String apiUrl = "http://" + baseUrl;
  IOWebSocketChannel chatRoomChannel;

  List<ChatRoom> _userChatRooms;

  bool get isInit {
    return _userChatRooms != null;
  }

  List<ChatRoom> get chatRooms {
    return _userChatRooms;
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
      if (chatRoomsRaw != null) {
        for (var c in chatRoomsRaw) {
          ChatRoom cr = ChatRoom.fromMap(c);
          chatRooms.add(cr);
        }
      }

      _userChatRooms = chatRooms;
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

      ChatRoom retrievedRoom = _userChatRooms.firstWhere((r) => r.id == roomID);
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

  Future<void> subscribeUserChatRoom() async {
    String url = "ws://" + apiUrl + "/chat-room/user/subsrible";

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
      // Updating local info
      print(updateDetails); // check how this will print
      // put a switch here for handling incomming?
      // _user = User.fromMap(json.decode(u));
      notifyListeners();
    });
  }
}
