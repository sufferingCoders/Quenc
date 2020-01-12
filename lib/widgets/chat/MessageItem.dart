import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/widgets/common/ContentShowingContainer.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key key,
    @required this.authorIsUser,
    @required this.message,
  }) : super(key: key);

  final bool authorIsUser;
  final Message message;

  Widget getShowingContent() {
    switch (message.messageType) {
      case 0:
        return ContentShowingContainer(
          content: message.content,
        );
        break;

      case 1:
        return Image.memory(Uint8List.fromList(message.content.codeUnits));
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          authorIsUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!authorIsUser)
          Container(
            margin: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message.author.photoURL),
            ),
          ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: getShowingContent(),
        )
      ],
    );
  }
}
