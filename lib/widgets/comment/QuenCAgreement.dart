import 'package:flutter/material.dart';

class QuenCAgreement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuenC 使用者協議"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("1. 請勿張貼任何暴力、色情或其他令人感到不適之內容。"),
            Text("2. 請勿發表任和種族、民族和政黨之對立的仇恨文字。"),
            Text("3. 此為討論和互助平台，請勿發佈任何商業消息。"),
          ],
        ),
      ),
    );
  }
}
