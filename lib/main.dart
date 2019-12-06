import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/screens/AllPostsScreen.dart';
import 'package:quenc/screens/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("brightness")) {
    brightness = Brightness.light;
  }

  if (prefs.getString("brightness") == "dark") {
    brightness = Brightness.dark;
  } else {
    brightness = Brightness.light;
  }
  return runApp(MyApp(
    brightness: brightness,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Brightness brightness;

  MyApp({this.brightness});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: Consumer<FirebaseUser>(
        builder: (ctx, fbUser, ch) {
          return StreamProvider<User>.value(
            value: UserService().userStream(fbUser),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              title: 'QuenC',
              theme: ThemeData(
                accentColor: Colors.teal[200],
                primarySwatch: Colors.teal,
                brightness: brightness,
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.teal[400],
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              home: fbUser != null
                  ? AllPostsScreen(
                      fbuser: fbUser,
                    ) // Main Screen
                  : FutureBuilder(
                      future: UserService().tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Container() // SplashScreen
                              : AuthScreen(), //AuthScreen
                    ),
              routes: {},
            ),
          );
        },
      ),
    );
  }
}
