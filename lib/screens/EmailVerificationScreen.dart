import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/widgets/AppDrawer.dart';
import 'package:quenc/widgets/Auth/EmailCheckingNotification.dart';

class EmailVerificationScreen extends StatelessWidget {
  static const String routeName = "/email-verification";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("信箱認證"),
        ),
        drawer: AppDrawer(),
        body: EmailCheckingNotification(
          user: Provider.of<UserGolangService>(context).user,
        ));
  }
}
