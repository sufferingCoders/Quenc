import 'package:flutter/material.dart';
import 'package:quenc/widgets/AuthCard.dart';

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
                    Icon(
                      Icons.shopping_cart,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      "昆客",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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


