import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryColor;
    double screenWith = MediaQuery.of(context).size.width;

    // Color textColor = Colors.white;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWith * 0.1),
            child: FittedBox(
              child: Text(
                "QuenC",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWith * 0.3),
            child: FittedBox(
              child: Text(
                "昆嗑",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /**
           * Logo
           */
          // Flexible(
          //   flex: 1,
          //   child: Text(
          //     "Q",
          //     style: TextStyle(
          //       fontSize: 250,
          //       color: textColor,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }
}
