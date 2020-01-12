import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/chat/MessageItem.dart';

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
  TextEditingController _sendController = TextEditingController();

  File currentImage;
  ScrollController _scrollController = ScrollController();

  Future<void> _pickImage(ImageSource source) async {
    currentImage = null;

    File selected = await ImagePicker.pickImage(
      source: source,
      maxWidth: 1936,
      maxHeight: 1936,
      imageQuality: 40,
    );

    setState(() {
      currentImage = selected;
    });
  }

  Future<void> _submit() {
    Message newMessage;
    if (currentImage != null) {
      // sending image

      newMessage = Message(
        content: String.fromCharCodes(currentImage.readAsBytesSync().toList()),
        messageType: 1,
        likeBy: [],
        readBy: [],
        createdAt: DateTime.now(),
      );
    } else {
      newMessage = Message(
        content: _sendController.text,
        messageType: 0,
        likeBy: [],
        readBy: [],
        createdAt: DateTime.now(),
      );
    }

    // sending text here

    Provider.of<UserGolangService>(context)
        .addMessageToChatRoom(widget.chatRoom.id, newMessage);
  }

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
        chatRoomName = anotherMember.name;
      }
    }
  }

  void loadMoreMessageForThisRoom() {
    Provider.of<UserGolangService>(context).getMessagesForARoom(
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
      body: Consumer<UserGolangService>(builder: (context, userService, ch) {
        return ListView.builder(
          // using this one or singleChildScrollView
          controller: _scrollController,
          itemCount: widget.chatRoom.messages.length,
          itemBuilder: (ctx, idx) {
            // Checking who own the message

            bool authorIsUser =
                widget.chatRoom.messages[idx].author == userService.user.id;

            // 本篇作者發的文所以靠右

            // 若和上一個發文相差一天以上 則增加天的分割點
            if (idx == 0) {
              // 這層直接加上
            } else {
              if (!Utils.isSameDate(widget.chatRoom.messages[idx].createdAt,
                  widget.chatRoom.messages[idx - 1].createdAt)) {
                // 如果和上一個Message不是在同一天的話
                // 加上日期
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("E, dd/MMM/yyyy")
                          .format(widget.chatRoom.messages[idx].createdAt)),
                    ),
                    MessageItem(
                      authorIsUser: authorIsUser,
                      message: widget.chatRoom.messages[idx],
                    ),
                  ],
                );
              }
            }
            return MessageItem(
              authorIsUser: authorIsUser,
              message: widget.chatRoom.messages[idx],
            );
          },
        );
      }), //顯示訊息 規範訊息type
      // 在Bottom做輸入框
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Row(
            // or using wrap
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  // Picking image here
                  _pickImage(ImageSource.camera);
                },
              ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              currentImage == null
                  ? Expanded(
                      child: TextField(
                        maxLines: 4,
                        controller: _sendController,
                        decoration: const InputDecoration(
                          // labelText: "標題",
                          // border: InputBorder.none,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )
                  : Stack(
                      overflow: Overflow.visible,
                      // alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                currentImage = null;
                              });
                            },
                          ),
                        ),
                        Image.file(currentImage),
                      ],
                    ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ), // function of adding image
    );
  }
}
