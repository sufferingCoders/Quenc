import 'package:flutter/material.dart';
import 'package:quenc/widgets/Auth/AuthCard.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "QuenC",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Icon(
                    //   Icons.shopping_cart,
                    //   size: 100,
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    Text(
                      "昆嗑",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
