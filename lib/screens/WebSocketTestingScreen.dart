import 'package:flutter/material.dart';
import 'package:quenc/providers/WebsocketServiceTest.dart';

class WebSocketTestingScreen extends StatelessWidget {
  static const routeName = "/websocket-test";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Test"),
      ),
      body: ListView(
        children: <Widget>[
          FlatButton(
            child: Text("Send"),
            onPressed: () {
              print("pressed");
              WebScoketService().sendingWebSocketTest();
            },
          ),
          FlatButton(
            child: Text("Send Ping"),
            onPressed: () {
              print("pressed");
              WebScoketService().sendingPing();
            },
          ),
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              print("pressed close");
              WebScoketService().closeWS();
            },
          )
        ],
      ),
    );
  }
}
