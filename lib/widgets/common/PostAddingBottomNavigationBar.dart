import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quenc/widgets/common/CameraAlbumnPreviewFunctionBar.dart';
import 'package:quenc/widgets/common/ImageUploadCard.dart';

class PostAddingBottomNavigationBar extends StatelessWidget {
  const PostAddingBottomNavigationBar({
    Key key,
    @required this.currentInsertImage,
    @required StorageUploadTask uploadTask,
    @required this.currentFilePath,
    this.addingImageMarkdownToContent,
    this.cropImage,
    this.currentUploadURLUpdater,
    this.startUploadImage,
    this.pickImage,
    this.previewButtonPress,
  })  : _uploadTask = uploadTask,
        super(key: key);
  final File currentInsertImage;
  final StorageUploadTask _uploadTask;
  final String currentFilePath;

  final Function addingImageMarkdownToContent;
  final Function cropImage;
  final Function currentUploadURLUpdater;
  final Function startUploadImage;
  final Function pickImage;
  final Function previewButtonPress;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        child: Wrap(
          children: <Widget>[
            if (currentInsertImage != null)
              ImageUploadCard(
                currentInsertImage: currentInsertImage,
                uploadTask: _uploadTask,
                currentFilePath: currentFilePath,
                addingImageMarkdownToContent: addingImageMarkdownToContent,
                cropImage: cropImage,
                currentUploadURLUpdater: currentUploadURLUpdater,
                startUploadImage: startUploadImage,
              ),
            CameraAlbumnPreviewFunctionBar(
              pickImage: pickImage,
              previewButtonPress: previewButtonPress,
            ),
          ],
        ),
      ),
    );
  }
}
