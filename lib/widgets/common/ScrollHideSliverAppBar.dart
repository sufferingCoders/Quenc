import 'package:flutter/material.dart';

class ScrollHideSliverAppBar extends StatelessWidget {
  const ScrollHideSliverAppBar({
    Key key,
    @required this.titleText,
    this.actions,
  }) : super(key: key);

  final List<Widget> actions;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(titleText),
      floating: true,
      snap: true,
      centerTitle: true,
      actions: actions ?? <Widget>[],
    );
  }
}
