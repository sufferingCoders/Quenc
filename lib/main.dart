import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/PostCategory.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentGolangService.dart';
import 'package:quenc/providers/CommentService.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/ReportService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/providers/UserService.dart';
import 'package:quenc/screens/AuthScreen.dart';
import 'package:quenc/screens/CategoryManagemnetScreen.dart';
import 'package:quenc/screens/EmailVerificationScreen.dart';
import 'package:quenc/screens/OwningPostsScreen.dart';
import 'package:quenc/screens/PostDetailScreen.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/screens/ReportDetailShowingScreen.dart';
import 'package:quenc/screens/ReportManagementScreen.dart';
import 'package:quenc/screens/SavedPostsScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';
import 'package:quenc/screens/WebSocketTestingScreen.dart';
import 'package:quenc/widgets/common/HomePage.dart';

import 'providers/WebsocketServiceTest.dart';

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
  Brightness brightness;

  MyApp({this.brightness});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<FirebaseUser>.value(
        //   value: FirebaseAuth.instance.onAuthStateChanged,
        // ),
        // ChangeNotifierProvider.value(
        //   value: PostService(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: CommentService(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: ReportService(),
        // ),
        ChangeNotifierProvider.value(
          value: WebScoketService(),
        ),

        ChangeNotifierProvider.value(
          value: UserGolangService(),
        ),

        ChangeNotifierProvider.value(
          value: PostGolangService(),
        ),

        ChangeNotifierProvider.value(
          value: CommentGolangService(),
        ),
        ChangeNotifierProvider.value(
          value: ReportGolangService(),
        )
      ],
      child: Consumer<FirebaseUser>(
        builder: (ctx, fbUser, ch) {
          return MaterialApp(
            onGenerateRoute: (setting) {
              switch (setting.name) {
                case ReportDetailShowingScreen.routeName:
                  return MaterialPageRoute(
                    builder: (context) {
                      final ReportDetailRouterArg args = setting.arguments;

                      if (args.report != null) {
                        return ReportDetailShowingScreen(
                          report: args.report,
                        );
                      }

                      return ReportDetailShowingScreen(
                        reportId: args.reportId,
                      );
                    },
                  );
                  break;
                case PostDetailScreen.routeName:
                  return MaterialPageRoute(
                    builder: (context) {
                      final String postId = setting.arguments;
                      return PostDetailScreen(
                        postId: postId,
                      );
                    },
                  );
                  break;
                case UserAttributeSettingScreen.routeName:
                  return MaterialPageRoute(
                    builder: (context) {
                      return UserAttributeSettingScreen(
                        user: setting.arguments as User,
                      );
                    },
                  );
                  break;
                default:
                  return MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      body: Center(
                        child: Text("無此頁面"),
                      ),
                    );
                  });
                  break;
              }
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
                    ? HomePage(
                        fbUser: fbUser,
                      )
                    : EmailVerificationScreen(
                        fbUser: fbUser,
                      ) // Main Screen

                : FutureBuilder(
                    future:
                        Provider.of<UserGolangService>(context).tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container() // SplashScreen
                            : AuthScreen(), //AuthScreen
                  ),
            routes: {
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              SavedPostscreen.routeName: (ctx) => SavedPostscreen(),
              OwingPostsScreen.routeName: (ctx) => OwingPostsScreen(),
              CategoryManagementScreen.routeName: (ctx) =>
                  CategoryManagementScreen(),
              ReportManagementScreen.routeName: (ctx) =>
                  ReportManagementScreen(),
              WebSocketTestingScreen.routeName: (ctx) =>
                  WebSocketTestingScreen(),
            },
          );
        },
      ),
    );
  }
}
