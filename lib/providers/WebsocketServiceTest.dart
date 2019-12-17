import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class WebScoketService {
  // MacOS // static const String apiUrl = "http://192.168.1.112:8080/";

  static const String apiURL = "http://192.168..1:8080/";
  static IOWebSocketChannel channel;

  Future<void> sendingTestTo(String u) async {
    String url =
        "http://192.168.1.135:8080/ws"; // ipconfig can check should be IPv4 Address

    print("sending url is ${url}");

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

  Future<void> sendingWebSocketTest() async {
    String url =
        "ws://192.168.1.135:8080/ws"; // ipconfig can check should be IPv4 Address
    channel = IOWebSocketChannel.connect(url);
    channel.sink.add("ping");
    channel.stream.listen((m) {
      print(m);
    });
    // channel.sink.close();
  }

    Future<void> sendingPing() async {

    channel.sink.add("ping");

    // channel.sink.close();
  }


  Future<void> closeWS() async {
    channel.sink.close();
    // channel.sink.close();
  }
}
