import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Widget getShowingContent(BuildContext ctx) {
    switch (message.messageType) {
      case 0: // 系統訊息
        // system message
        return Container(
          margin: EdgeInsets.all(12),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color: Theme.of(ctx).secondaryHeaderColor,
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 1: //文字

        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Theme.of(ctx).primaryColorLight,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            margin: EdgeInsets.all(10), // 5e247f4a1c9d4400007e5c21
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.7),
            child: ContentShowingContainer(
              content: message.content,
            ));

        break;

      case 2: //圖片

        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Theme.of(ctx).primaryColorLight,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            margin: EdgeInsets.all(10), // 5e247f4a1c9d4400007e5c21
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.7),
            child: Image.memory(Uint8List.fromList(message.content.codeUnits)));

        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.messageType == 0
          ? MainAxisAlignment.center
          : authorIsUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (authorIsUser &&
            message.createdAt != null &&
            message.messageType != 0)
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.1),
            child: Text(
              "${DateFormat("h:mm a").format(message.createdAt)}",
              style: TextStyle(fontSize: 9),
            ),
          ),
        if (!authorIsUser && message.messageType != 0)
          Container(
            margin: EdgeInsets.all(10),
            child: message?.author?.photoURL == null ||
                    message?.author?.photoURL?.isEmpty == true
                ? CircleAvatar(
                    backgroundColor: message?.author?.gender == 0
                        ? Colors.pink[200]
                        : Colors.blue[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )

                // Container(
                //     color: message?.author?.gender == 0
                //         ? Colors.pink
                //         : Colors.blue,
                //   )
                : CircleAvatar(
                    backgroundImage: NetworkImage(message?.author?.photoURL),
                  ),
          ),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(20.0)),
        //     color: Theme.of(context).primaryColorLight,
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        //   margin: EdgeInsets.all(10), // 5e247f4a1c9d4400007e5c21
        //   constraints:
        //       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        //   child: getShowingContent(context),
        // ),

        getShowingContent(context),

        if (!authorIsUser &&
            message.createdAt != null &&
            message.messageType != 0)
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.1),
            child: Text(
              "${DateFormat("h:mm a").format(message.createdAt)}",
              style: TextStyle(fontSize: 9),
            ),
          ),
      ],
    );
  }
}
