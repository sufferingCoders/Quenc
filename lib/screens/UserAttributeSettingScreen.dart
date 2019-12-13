import 'package:flutter/material.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/widgets/Auth/AttributeSettingCard.dart';

class UserAttributeSettingScreen extends StatelessWidget {
  static const String routeName = "/user-arttribute-setting";

  final User user;

  UserAttributeSettingScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("個人檔案"),
        ),
        // drawer: AppDrawer(),
        body: AttributeSettingCard(
          user: user,
        ) // Ask ,
        );
  }
}
