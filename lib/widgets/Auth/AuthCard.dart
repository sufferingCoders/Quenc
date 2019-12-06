import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quenc/providers/UserService.dart';

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var registerMode = false;
  String email = "";
  String password = "";
  String passwordAgain = "";

  void _showErrorDialog(String message) {
    /*
        Show Error Message inside the dialog
      */
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('錯誤'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<Void> _submit(BuildContext ctx) async {
    /*
        Registering or Logging 
      */
    if (!_formKey.currentState.validate()) {
      return null;
    }
    try {
      if (registerMode) {
        Scaffold.of(ctx).removeCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text("註冊使用者中..."),
            duration: Duration(milliseconds: 2000),
          ),
        );
        await UserService().signupWithEmailAndPassword(email, password);
      } else {
        Scaffold.of(ctx).removeCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text("登入中..."),
            duration: Duration(milliseconds: 2000),
          ),
        );
        await UserService().loginWithEmailAndPassword(email, password);
      }
    } catch (error) {
      const errorMessage = '未能認證你的Email，請稍後再嘗試';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: mediaQueryData.size.width > 500
              ? mediaQueryData.size.width * 0.2
              : 10),
      // height: registerMode ? 295 : 235,
      // duration: Duration(milliseconds: 300),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (v) {
                    email = v;
                  },
                  decoration: InputDecoration(labelText: "學校信箱"),
                  validator: (v) {
                    if (v.isEmpty || !v.contains("@")) {
                      return "無效的Email";
                    }

                    /* Verifying the Uni Email */
                    List<String> emailParts = v.split("@");

                    // Assume that the emailParts should be length of 2
                    if (emailParts.length != 2) {
                      return "Email未使用標準格式";
                    }

                    // String account = emailParts[0];
                    String domain = emailParts[1];

                    // Check if it belong to the uni email;
                    if (!domain.contains(".edu.")) {
                      return "必須使用學校Email";
                    }

                    // Selective uni
                    if (!domain
                        .contains(new RegExp(r'qut\.|uq\.|griffith\.'))) {
                      return "現在只提供QUT, UQ 或 Griffith的Email註冊，請見諒";
                    }
                  },
                ),
                TextFormField(
                  onChanged: (v) {
                    password = v;
                  },
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密碼"),
                  validator: (v) {
                    if (v.isEmpty || v.length < 6) {
                      return "密碼必須多餘6個字元";
                    }
                  },
                ),
                if (registerMode)
                  TextFormField(
                    onChanged: (v) {
                      passwordAgain = v;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: "密碼確認"),
                    validator: (v) {
                      if (v.isEmpty) {
                        return "密碼必須多餘6個字元";
                      }

                      if (password != passwordAgain) {
                        return "密碼並不相同";
                      }
                    },
                  ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text(registerMode ? "註冊" : "登入"),
                  onPressed: () => _submit(context),
                ),
                FlatButton(
                  child:
                      Text("我要${registerMode ? "登入" : "註冊"}"),
                  onPressed: () {
                    setState(() {
                      registerMode = !registerMode;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
