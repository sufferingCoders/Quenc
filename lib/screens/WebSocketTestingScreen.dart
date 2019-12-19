import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/WebsocketServiceTest.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    idController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<WebScoketService>(context).currentId;
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
              await Provider.of<WebScoketService>(context, listen: false)
                  .addTestDocument(emailController.text);

              Provider.of<WebScoketService>(context).setTestDocumentStream();
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
          FlatButton(
            child: Text("Get Stream"),
            onPressed: () {
              print("stream Pressed");
            },
          ),
          Builder(
            builder: (
              context,
            ) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("CurrentId is $id"),
                ),
              );
            },
          ),
          Builder(
            builder: (
              context,
            ) {
              return FlatButton(
                child: Text("Copy and Put into ID field"),
                onPressed: () {
                  ClipboardManager.copyToClipBoard(id).then((r) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Copied"),
                      duration: Duration(
                        seconds: 3,
                      ),
                    ));
                  });
                  setState(() {
                    idController.text = id;
                  });
                },
              );
            },
          ),
          Builder(
            builder: (context) {
              if (id != null) {
                return StreamBuilder(
                  stream: Provider.of<WebScoketService>(context)
                      .currentChannel
                      .stream, // Extract the fullDocument part and setting in the user
                  builder: (context, snapshot) {


                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data.toString()),
                      );
                    }

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("No Data now"),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No id"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
