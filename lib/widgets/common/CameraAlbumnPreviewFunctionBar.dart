import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAlbumnPreviewFunctionBar extends StatelessWidget {
  const CameraAlbumnPreviewFunctionBar(
      {Key key, this.pickImage, this.previewButtonPress})
      : super(key: key);
  final Function pickImage;
  final Function previewButtonPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.photo_camera),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("相機"),
              ),
            ],
          ),
          // icon: Icon(Icons.photo_camera),
          onPressed: () {
            pickImage(ImageSource.camera);
          },
        ),
        FlatButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.image),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("相簿"),
              ),
            ],
          ),
          // icon: Icon(Icons.image),
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
        ),
        FlatButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.remove_red_eye),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("預覽"),
              ),
            ],
          ),
          // icon: ,
          onPressed: () {
            previewButtonPress();

            // bool ok = prepairPostForPreview();
            // if (ok) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) {
            //         final dialog = PostPreviewFullScreenDialog(
            //           // inputText: contentController.text,
            //           post: post,
            //         );
            //         return dialog;
            //       },
            //       fullscreenDialog: true,
            //     ),
            //   );
            // }
          },
        )
      ],
    );
  }
}
