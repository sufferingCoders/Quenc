import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/screens/MainScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser fbUser;

  const HomePage({
    Key key,
    @required this.fbUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (ctx, user, ch) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!(user?.haveAttributesSet() == true)) {
          return UserAttributeSettingScreen(
            user: user,
          );
        }
        return MainScreen(
          fbUser: fbUser,
        );
      },
    );
  }
}
