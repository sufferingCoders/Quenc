import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/ChatScreen.dart';
import 'package:quenc/utils/index.dart';

class ChatRoomShowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserGolangService>(context).tryInitChatRooms(),
      builder: (ctx, snapshot) {
        DateTime currentTime = DateTime.now();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<ChatRoom> chatRoomList =
            Provider.of<UserGolangService>(context).chatRoomList;

        User currentUser = Provider.of<UserGolangService>(context).user;

        if (chatRoomList.length == 0) {
          return Center(
            child: Text("未有聊天室"),
          );
        }

        return ListView.builder(
          itemCount: chatRoomList.length,
          itemBuilder: (ctx, idx) {
            String leadingImageURL;
            String chatRoomName;
            Message showingMessage = chatRoomList[idx].messages[-1];

            if (chatRoomList[idx].isGroup) {
              leadingImageURL = chatRoomList[idx].groupPhotoUrl;
              chatRoomName = chatRoomList[idx].groupName;
            } else {
              User anotherMember = chatRoomList[idx]
                  .members
                  .firstWhere((m) => m.id != currentUser.id);

              leadingImageURL = anotherMember.photoURL;
              chatRoomName = anotherMember.name;
            }

            return ListTile(
              leading: leadingImageURL == null || leadingImageURL.isEmpty
                  ? Icon(
                      Icons.group,
                      color: Theme.of(context).primaryColor,
                    )
                  : Image.network(leadingImageURL),
              title: Text(chatRoomName ?? "未輸入名稱"),
              subtitle: showingMessage != null
                  ? Text(
                      "${showingMessage.author.name} : ${showingMessage.messageType == 0 ? showingMessage.content : "傳送了一張圖片"}")
                  : Container(),
              trailing: Text(
                Utils.isSameDate(currentTime, showingMessage.createdAt)
                    ? DateFormat("H:mm").format(showingMessage.createdAt)
                    : DateFormat("dd/M/yyyy").format(showingMessage.createdAt),
              ),
              onLongPress: () {}, // selection here
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.routeName,
                  arguments: chatRoomList[idx],
                );
              },
            );
          },
        );
      },
    );
  }
}
