import 'package:flutter/material.dart';
import 'package:quenc/screens/ChatScreen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  int idx;
  Function idxUpdateFunc;

  AppBottomNavigationBar({
    this.idx,
    this.idxUpdateFunc,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (idx) => idxUpdateFunc(idx),
      currentIndex: idx,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          title: Text("Chat"),
        ),
      ],
    );
    // return BottomAppBar(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.home),
    //         onPressed: () {
    //           Navigator.pushNamed(
    //             context,
    //             "/",
    //           );
    //         },
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.chat_bubble),
    //         onPressed: () {
    //           Navigator.pushReplacementNamed(
    //             context,
    //             ChatScreen.routeName,
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
