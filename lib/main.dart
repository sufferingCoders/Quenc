import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/ChatRoom.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentGolangService.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/screens/CategoryManagemnetScreen.dart';
import 'package:quenc/screens/ChatScreen.dart';
import 'package:quenc/screens/HomeScreen.dart';
import 'package:quenc/screens/OwningPostsScreen.dart';
import 'package:quenc/screens/PostDetailScreen.dart';
import 'package:quenc/screens/ProfileScreen.dart';
import 'package:quenc/screens/ReportDetailShowingScreen.dart';
import 'package:quenc/screens/ReportManagementScreen.dart';
import 'package:quenc/screens/SavedPostsScreen.dart';
import 'package:quenc/screens/UserAttributeSettingScreen.dart';
import 'package:quenc/screens/WebSocketTestingScreen.dart';

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
        ChangeNotifierProvider.value(
          value: UserGolangService(),
        ),
        ChangeNotifierProvider.value(
          value: WebScoketService(),
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
      child: MaterialApp(
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

            case ChatScreen.routeName:
              return MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(
                    chatRoom: setting.arguments as ChatRoom,
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
        home: HomeScreen(),
        routes: {
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          SavedPostscreen.routeName: (ctx) => SavedPostscreen(),
          OwingPostsScreen.routeName: (ctx) => OwingPostsScreen(),
          CategoryManagementScreen.routeName: (ctx) =>
              CategoryManagementScreen(),
          ReportManagementScreen.routeName: (ctx) => ReportManagementScreen(),
          WebSocketTestingScreen.routeName: (ctx) => WebSocketTestingScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
        },
      ),
    );
  }
}
