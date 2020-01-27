import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/widgets/chat/RandomChatShowingContainer.dart';

class RandomChatRoom extends StatefulWidget {
  @override
  _RandomChatRoomState createState() => _RandomChatRoomState();
}

class _RandomChatRoomState extends State<RandomChatRoom>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void joinSuccessHandler(BuildContext ctx, bool success) {
    switch (success) {
      case false:
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("錯誤"),
                  content: Text("連線錯誤, 請稍後重試"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ));
        break;
      case true:
        break;

      default:
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("錯誤"),
                  content: Text("目前無閒置人員可連接, 請稍後再試"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserGolangService>(
      builder: (ctx, userService, ch) {
        if (!userService.user.hasRandomChatRoom) {
          // connecting
          // 若沒有的話顯示連接按鈕
          // 只有檔案庫的是實時的

          // if (本地的randomChat有的話, 則將本地的randomChat忽略)

          return Center(
            child: RaisedButton(
              child: Text("加入聊天"),
              onPressed: () async {
                bool success = await userService.initialiseRandomChatRoom();
                joinSuccessHandler(ctx, success);
              },
            ),
          );
        } else {
          // 若有的話直接連接

          // 如果檔案庫有的話, 若本地的randomChatroom跟WebSocket的Channel都在的話 則直接顯示

          if (userService.randomChatRoom == null) {
            // try initialise random chat room
            userService.tryInitialiseRandomChatRoom().then((success) {
              joinSuccessHandler(ctx, success);
            }); // 取得Detail跟WebSocket連接

            return Center(child: CircularProgressIndicator());
          }

          if (!userService.isRandomChatRoomReady) {
            return Center(child: CircularProgressIndicator());
          }

          // if the currentRandomChatRoom exist

          return RandomChatShowingContainer(
            random: userService.randomChatRoom,
          );
        }

        // we need to get current message
      },
    );
  }
}
