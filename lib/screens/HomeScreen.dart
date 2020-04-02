import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/AuthScreen.dart';
import 'package:quenc/screens/EmailVerificationScreen.dart';
import 'package:quenc/screens/SplashScreen.dart';
import 'package:quenc/widgets/common/HomePage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserGolangService>(context).user;

    return Consumer<UserGolangService>(
      builder: (ctx, userService, ch) {
        return userService.user != null
            ? userService.user.emailVerified == true
                ? HomePage()
                : EmailVerificationScreen() // Main Screen

            : FutureBuilder(
                future: Provider.of<UserGolangService>(context, listen: false)
                    .tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen() // SplashScreen
                        : AuthScreen(), //AuthScreen
              );
      },
    ); 
  }
}
