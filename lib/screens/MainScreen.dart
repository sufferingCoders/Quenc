import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/Auth/AttributeSettingCard.dart';
import 'package:quenc/widgets/Auth/EmailCheckingNotification.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/";
  final userService = UserService();
  final FirebaseUser fbUser;

  MainScreen({this.fbUser});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuenC"),
      ),
      drawer: AppDrawer(),
      body: fbUser.isEmailVerified
          ? Consumer<User>(
              builder: (ctx, user, ch) {
                if (!(user != null && user.haveAttributesSet())) {
                  return AttributeSettingCard(
                    user: user,
                  ); // Ask the user to fill the profile
                }

                return Center(
                  child: Text("All Posts Here"),
                );
              },
            )
          : EmailCheckingNotification(
              fbUser: fbUser,
            ),
    );
  }
}
