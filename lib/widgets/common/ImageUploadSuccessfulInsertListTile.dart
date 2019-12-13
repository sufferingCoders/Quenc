import 'package:flutter/material.dart';

class ImageUploadSuccessfulInsertListTile extends StatelessWidget {
  final Function insertFunc;

  ImageUploadSuccessfulInsertListTile(this.insertFunc);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("上傳成功"),
      trailing: FlatButton(
        child: Text(
          "插入",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          insertFunc();
        },
      ),
    );
  }
}
