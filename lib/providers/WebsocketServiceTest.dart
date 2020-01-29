import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

/// Testing the WebSocket Connection
class WebScoketService with ChangeNotifier {
  // MacOS // static const String apiUrl = "http://192.168.1.112:8080/";

  IOWebSocketChannel channel;
  String insertedID;

  IOWebSocketChannel get currentChannel {
    return channel;
  }

  String get currentId {
    return insertedID;
  }

  /// Sending the websocket connection request to backend
  Future<void> sendingTestTo(String u) async {
    String url =
        "http://192.168.1.135:8080/ws"; // ipconfig can check should be IPv4 Address

    print("sending url is $url");

    final res = await http.get(
      url,
    );

    if (res.body == null || res.body.isEmpty) {
      return;
    }

    print(res.body);

    final resData = json.decode(res.body);

    print(resData);
  }

  /// Sending the message to backend through websocket
  Future<void> sendingWebSocketTest() async {
    String url =
        "ws://192.168.1.135:8080/ws"; // ipconfig can check should be IPv4 Address
    channel = IOWebSocketChannel.connect(url);
    channel.stream.listen((m) {
      print(m);
    });
  }

  /// Get the stream that reading the message from backend
  Future<void> setTestDocumentStream() async {
    String url =
        "ws://192.168.1.135:8080/test/subscribe/$insertedID"; // ipconfig can check should be IPv4 Address

    if (channel != null) {
      await channel.sink.close();
    }
    channel = IOWebSocketChannel.connect(url);
    // channel.sink.add("ping");
    channel.stream.listen((m) {
      print("get stream: $m");
    });
  }

  /// Adding test to backend
  Future<String> addTestDocument(String email) async {
    if (email == null || email.isEmpty) {
      return null;
    }
    final String url = "http://192.168.1.135:8080/test";
    final res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: json.encode(
        {
          "email": email,
        },
      ),
    );

    if (res.body == null || res.body.isEmpty) {
      return null;
    }

    final resData = json.decode(res.body);

    print("resData is ${resData.toString()}");

    // Have to return ID here;

    insertedID = resData["id"];

    return resData["id"];
  }

  /// Update test in the database
  Future<dynamic> updateTestDocument(String id, String email) async {
    if (id == null || id.isEmpty) {
      if (insertedID == null) {
        return null;
      } else {
        id = insertedID;
      }
    }

    final String url = "http://192.168.1.135:8080/test/$id";
    final res = await http.put(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: json.encode(
        {
          "email": email,
        },
      ),
    );

    if (res.body == null || res.body.isEmpty) {
      return;
    }

    final resData = json.decode(res.body);

    print("resData is ${resData.toString()}");

    notifyListeners();
    return resData;
  }

  /// sendning "ping" meesage to backend through current websocket channel
  Future<void> sendingPing() async {
    channel.sink.add("ping");
  }

  /// close current websocket channel
  Future<void> closeWS() async {
    channel.sink.close();
    notifyListeners();
  }
}
