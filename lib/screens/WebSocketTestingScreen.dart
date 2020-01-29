import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/providers/WebsocketServiceTest.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketTestingScreen extends StatefulWidget {
  static const routeName = "/websocket-test";

  @override
  _WebSocketTestingScreenState createState() => _WebSocketTestingScreenState();
}

class _WebSocketTestingScreenState extends State<WebSocketTestingScreen> {
  List<Widget> connectionTest() {
    return <Widget>[
      FlatButton(
        child: Text("Send"),
        onPressed: () {
          print("pressed");
          Provider.of<WebScoketService>(context).sendingWebSocketTest();
        },
      ),
      FlatButton(
        child: Text("Send Ping"),
        onPressed: () {
          print("pressed");
          Provider.of<WebScoketService>(context).sendingPing();
        },
      ),
      FlatButton(
        child: Text("Close"),
        onPressed: () {
          print("pressed close");
          Provider.of<WebScoketService>(context).closeWS();
        },
      ),
    ];
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();

  IOWebSocketChannel channel;

  void settingWebsocket(String id) {
    String url = "ws://" +
        UserGolangService.baseUrl +
        "/test/subscribe/$id"; // ipconfig can check should be IPv4 Address

    channel = IOWebSocketChannel.connect(url);
    channel.stream.listen(
      (m) {
        Map newObj = json.decode(m);
        print(newObj);
        print("get stream: $m");
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) {
        debugPrint('ws error $error');
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    idController.dispose();
    channel?.sink?.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Test"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text("Close"),
              onPressed: () {
                print("pressed close");
                Provider.of<WebScoketService>(context).closeWS();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
              controller: emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ID",
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
              controller: idController,
            ),
          ),
          FlatButton(
            child: Text("Create"),
            onPressed: () async {
              print("Create Pressed");
              var id =
                  await Provider.of<WebScoketService>(context, listen: false)
                      .addTestDocument(emailController.text);
              if (id != null) {
                settingWebsocket(id);
              }
              setState(() {
                idController.text = id;
              });

              // Provider.of<WebScoketService>(context, listen: false)
              //     .setTestDocumentStream();
            },
          ),
          FlatButton(
            child: Text("Update"),
            onPressed: () {
              print("update Pressed");
              Provider.of<WebScoketService>(context, listen: false)
                  .updateTestDocument(idController.text, emailController.text);
            },
          ),
          // FlatButton(
          //   child: Text("Get Stream"),
          //   onPressed: () {
          //     print("stream Pressed");
          //   },
          // ),
          // Builder(
          //   builder: (
          //     context,
          //   ) {
          //     return Center(
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text("CurrentId is $id"),
          //       ),
          //     );
          //   },
          // ),
          // Builder(
          //   builder: (
          //     context,
          //   ) {
          //     return FlatButton(
          //       child: Text("Copy and Put into ID field"),
          //       onPressed: () {
          //         ClipboardManager.copyToClipBoard(id).then((r) {
          //           Scaffold.of(context).showSnackBar(SnackBar(
          //             content: Text("Copied"),
          //             duration: Duration(
          //               seconds: 3,
          //             ),
          //           ));
          //         });
          //         setState(() {
          //           idController.text = id;
          //         });
          //       },
          //     );
          //   },
          // ),
          // Builder(
          //   builder: (context) {
          //     if (id != null) {
          //       return StreamBuilder(
          //         stream: Provider.of<WebScoketService>(context)
          //             .currentChannel
          //             .stream, // Extract the fullDocument part and setting in the user
          //         builder: (context, snapshot) {
          //           if (snapshot.hasData) {
          //             return Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(snapshot.data.toString()),
          //             );
          //           }

          //           return Center(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text("No Data now"),
          //             ),
          //           );
          //         },
          //       );
          //     } else {
          //       return Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Text("No id"),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
