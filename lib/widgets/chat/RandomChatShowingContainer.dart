import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/chat/MessageItem.dart';

class RandomChatShowingContainer extends StatefulWidget {
  ChatRoom random;

  RandomChatShowingContainer({this.random});

  @override
  _RandomChatShowingContainerState createState() =>
      _RandomChatShowingContainerState();
}

class _RandomChatShowingContainerState
    extends State<RandomChatShowingContainer> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scrollController.jumpTo(
    //     _scrollController.position.maxScrollExtent); // ir using animate to
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
    _scrollController.addListener(
      () {
        var isEnd = _scrollController.offset == 0.0;
        if (isEnd) {
          loadMoreMessageForThisRoom();
        }
      },
    );
  }

  Widget dateAndMessageColumn(Message message, bool authorIsUser) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Theme.of(context).secondaryHeaderColor,
          ),
          child: Text(
            DateFormat("E, dd/MMM/yyyy").format(message.createdAt),
            style: TextStyle(fontSize: 12),
          ),
        ),
        MessageItem(
          authorIsUser: authorIsUser,
          message: message,
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // if (_scrollController.hasClients) {
    //   _scrollController.jumpTo(
    //       _scrollController.position.maxScrollExtent); // ir using animate to
    // }
  }

  void loadMoreMessageForThisRoom() {
    Provider.of<UserGolangService>(context).getMessagesForRandomChatRoom(
      // 查看甚麼時候運行這個
      widget.random.messages[0].id,
      25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserGolangService>(
      builder: (ctx, userService, ch) {
        ChatRoom random = userService.randomChatRoom;

        if (random != null && random.id != null && random.id != null) {
          // the random chatroom exist
          Widget listview = ListView.builder(
            controller: _scrollController,
            itemCount: random.messages.length,
            itemBuilder: (ctx, idx) {

              bool authorIsUser =
                  random.messages[idx].author.id == userService.user.id;

              bool hasCreatedAt =
                  widget?.random?.messages[idx]?.createdAt != null;

              if (!hasCreatedAt) {
                return MessageItem(
                  authorIsUser: authorIsUser,
                  message: widget.random.messages[idx],
                );
              }

              if (idx == 0) {
                return dateAndMessageColumn(
                    widget.random.messages[idx], authorIsUser);
              }

              // do comparison
              bool sameDate = Utils.isSameDate(
                  widget.random.messages[idx]
                      .createdAt, // the 0 has been returned, so this one must be here
                  widget.random.messages[idx - 1].createdAt);

              if (sameDate == true) {
                // 如果和上一個Message不是在同一天的話
                // 加上日期

                return MessageItem(
                  authorIsUser: authorIsUser,
                  message: widget.random.messages[idx],
                );
              }

              return dateAndMessageColumn(
                  widget.random.messages[idx], authorIsUser);

              // if (idx == 0) {
              //   return MessageItem(
              //     authorIsUser: authorIsUser,
              //     message: widget.random.messages[idx],
              //   );
              //   // 這層直接加上
              // } else {
              //   if (widget?.random?.messages[idx]?.createdAt == null ||
              //       widget?.random?.messages[idx - 1]?.createdAt == null) {
              //     return MessageItem(
              //       authorIsUser: authorIsUser,
              //       message: widget.random.messages[idx],
              //     );
              //   }

              //   // if (sameDate == null) {
              //   //   return MessageItem(
              //   //     authorIsUser: authorIsUser,
              //   //     message: widget.random.messages[idx],
              //   //   );
              //   // }

              //   if (sameDate == true) {
              //     // 如果和上一個Message不是在同一天的話
              //     // 加上日期
              //     Column(
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(DateFormat("E, dd/MMM/yyyy")
              //               .format(widget.random.messages[idx].createdAt)),
              //         ),
              //         MessageItem(
              //           authorIsUser: authorIsUser,
              //           message: widget.random.messages[idx],
              //         ),
              //       ],
              //     );
              //   }
              // }
              // return MessageItem(
              //   authorIsUser: authorIsUser,
              //   message: widget.random.messages[idx],
              // );
            },
          );
          // if (_scrollController.hasClients) {
          //   _scrollController
          //       .jumpTo(_scrollController.position.maxScrollExtent);
          // }

          return listview;
        }
      },
    );
  }
}
