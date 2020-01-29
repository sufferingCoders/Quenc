import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/MainScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/";

  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserGolangService>(
      builder: (ctx, userService, ch) {
        if (userService?.user == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!(userService?.user?.haveAttributesSet() == true)) {
          return UserAttributeSettingScreen(
            user: userService.user,
          );
        }
        return MainScreen();
      },
    );
  }
}
