import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/AuthScreen.dart';
import 'package:quenc/screens/EmailVerificationScreen.dart';
import 'package:quenc/widgets/common/HomePage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserGolangService>(context).user;
    return user != null
        ? user.emailVerified == true
            ? HomePage()
            : EmailVerificationScreen() // Main Screen

        : FutureBuilder(
            future: Provider.of<UserGolangService>(context).tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? Container() // SplashScreen
                    : AuthScreen(), //AuthScreen
          );
  }
}
