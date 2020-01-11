import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/ChatRoomGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/ChatScreen.dart';

class ChatRoomShowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ChatRoomGolangService>(context).tryInitChatRooms(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<ChatRoom> chatRooms =
            Provider.of<ChatRoomGolangService>(context).chatRooms;

        User currentUser = Provider.of<UserGolangService>(context).user;

        if (chatRooms.length == 0) {
          return Center(
            child: Text("未有聊天室"),
          );
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (ctx, idx) {
            String leadingImageURL;
            String chatRoomName;
            Message showingMessage = chatRooms[idx].messages[-1];

            if (chatRooms[idx].isGroup) {
              leadingImageURL = chatRooms[idx].groupPhotoUrl;
              chatRoomName = chatRooms[idx].groupName;
            } else {
              User anotherMember = chatRooms[idx]
                  .members
                  .firstWhere((m) => m.id != currentUser.id);

              leadingImageURL = anotherMember.photoURL;
              chatRoomName = anotherMember.email;
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
                      "${showingMessage.author.email} : ${showingMessage.content}")
                  : Container(),
              trailing: Text("${showingMessage?.createdAt?.toString() ?? ""}"),
              onLongPress: () {}, // selection here
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.routeName,
                  arguments: chatRooms[idx],
                );
              },
            );
          },
        );
      },
    );
  }
}
