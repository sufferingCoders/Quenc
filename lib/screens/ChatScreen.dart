import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/ChatRoomGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/widgets/common/AppBottomNavigationBar.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat";
  static const chatPageSize = 50;
  ChatRoom chatRoom;

  ChatScreen({this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isInit = false;
  String chatRoomName;
  String leadingImageURL;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent); // ir using animate to

    _scrollController.addListener(
      () {
        var isEnd = _scrollController.offset == 0.0;
        if (isEnd) {
          loadMoreMessageForThisRoom();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      User currentUser = Provider.of<UserGolangService>(context).user;
      if (widget.chatRoom.isGroup) {
        leadingImageURL = widget.chatRoom.groupPhotoUrl;
        chatRoomName = widget.chatRoom.groupName;
      } else {
        User anotherMember =
            widget.chatRoom.members.firstWhere((m) => m.id != currentUser.id);
        leadingImageURL = anotherMember.photoURL;
        chatRoomName = anotherMember.email;
      }
    }
  }

  void loadMoreMessageForThisRoom() {
    Provider.of<ChatRoomGolangService>(context).getMessagesForARoom(
      widget.chatRoom.id,
      widget.chatRoom.messages[-1].id,
      ChatScreen.chatPageSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(leadingImageURL),
        title: Text(chatRoomName),
      ),
      body: ListView.builder(
        // using this one or singleChildScrollView
        controller: _scrollController,
        itemCount: widget.chatRoom.messages.length,
        itemBuilder: (ctx, idx) {

          // Checking who own the message

          return Row(
            children: <Widget>[],
          );
        },
      ), //顯示訊息 規範訊息type
      // 在Bottom做輸入框
    );
  }
}
