import 'package:flutter/material.dart';

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
  }
}
