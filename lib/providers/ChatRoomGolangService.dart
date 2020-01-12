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
  
}
