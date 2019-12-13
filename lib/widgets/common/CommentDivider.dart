import 'package:flutter/material.dart';

class CommentDivider extends StatelessWidget {
  const CommentDivider({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).primaryColorLight,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
