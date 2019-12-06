import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';

class EmailCheckingNotification extends StatefulWidget {
  final FirebaseUser fbUser;
  EmailCheckingNotification({this.fbUser});

  @override
  _EmailCheckingNotificationState createState() =>
      _EmailCheckingNotificationState();
}

class _EmailCheckingNotificationState extends State<EmailCheckingNotification> {
  int secCounting = 0;
  Timer _timer;
  bool availibleForSending = true;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            Text("您尚未完成Email認證"),
            Text("我們已經寄送認證信至 ${widget.fbUser.email}"),
            Text("請點擊認證信中的激活連結後，重新登入"),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text(
                      "再次寄送${availibleForSending ? "" : "($secCounting)"}"),
                  onPressed: availibleForSending
                      ? () {
                          secCounting = 5;
                          availibleForSending = false;
                          const oneSec = const Duration(seconds: 1);
                          _timer = new Timer.periodic(
                            oneSec,
                            (Timer timer) => setState(
                              () {
                                if (secCounting < 1) {
                                  availibleForSending = true;
                                  timer.cancel();
                                } else {
                                  secCounting = secCounting - 1;
                                }
                              },
                            ),
                          );
                          widget.fbUser.sendEmailVerification();
                        }
                      : null,
                ),
                RaisedButton(
                  child: Text("重新登入"),
                  onPressed: () {
                    UserService().signOut();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
