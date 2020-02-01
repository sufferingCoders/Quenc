import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserGolangService.dart';

class EmailCheckingNotification extends StatefulWidget {
  final User user;
  EmailCheckingNotification({this.user});

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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("您尚未完成Email認證"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("我們已經寄送認證信至 ${widget.user.email}"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("請點擊認證信中的激活連結後，重新登入"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
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
                          Provider.of<UserGolangService>(context)
                              .sendingEmailVerification();
                        }
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("重新登入"),
                  onPressed: () {
                    Provider.of<UserGolangService>(context)
                        .signOut();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
