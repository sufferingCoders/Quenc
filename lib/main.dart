import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/screens/ArchivePostsScreen.dart';
import 'package:quenc/screens/AuthScreen.dart';
import 'package:quenc/screens/CategoryManagemnetScreen.dart';
import 'package:quenc/screens/EmailVerificationScreen.dart';
import 'package:quenc/screens/MainScreen.dart';
import 'package:quenc/screens/PostDetailScreen.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';

void main() async {
  // Brightness brightness;
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // if (!prefs.containsKey("brightness")) {
  //   brightness = Brightness.light;
  // }

  // if (prefs.getString("brightness") == "dark") {
  //   brightness = Brightness.dark;
  // } else {
  //   brightness = Brightness.light;
  // }
  return runApp(MyApp(
    brightness: Brightness.light,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Brightness brightness;

  MyApp({this.brightness});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        //         ChangeNotifierProvider.value(
        //   value: UserService(),
        // ),
        ChangeNotifierProvider.value(
          value: PostService(),
        ),

        ChangeNotifierProvider.value(
          value: CommentService(),
        )
      ],
      child: Consumer<FirebaseUser>(
        builder: (ctx, fbUser, ch) {
          return StreamProvider<User>.value(
            value: UserService().userStream(fbUser),
            child: MaterialApp(
              onGenerateRoute: (setting) {
                if (setting.name == PostDetailScreen.routeName) {
                  return MaterialPageRoute(
                    builder: (context) {
                      final String postId = setting.arguments;
                      return PostDetailScreen(
                        postId: postId,
                      );
                    },
                  );
                }

                if (setting.name == UserAttributeSettingScreen.routeName) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return UserAttributeSettingScreen(
                        user: setting.arguments as User,
                      );
                    },
                  );
                }

                return MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    body: Center(
                      child: Text("無此頁面"),
                    ),
                  );
                });
              },
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
                  ? fbUser.isEmailVerified == true
                      // ? Center(
                      //     child: Text("Email Verified"),
                      //   )
                      ? Consumer<User>(
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
                        )
                      : EmailVerificationScreen(
                          fbUser: fbUser,
                        ) // Main Screen

                  // Problem may be here, the tryAutoLogin()
                  : FutureBuilder(
                      future: UserService().tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? Center(
                                  child: Text("Splash Screen"),
                                ) // SplashScreen
                              : AuthScreen(), //AuthScreen
                    ),
              routes: {
                // MainScreen.routeName: (ctx) => MainScreen(),
                ProfileScreen.routeName: (ctx) => ProfileScreen(),
                ArchivePostScreen.routeName: (ctx) => ArchivePostScreen(),
                CategoryManagementScreen.routeName: (ctx) =>
                    CategoryManagementScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}
