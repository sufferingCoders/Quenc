import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quenc/widgets/common/ImageUploadEventsStreamBuilderButtomFunctionBar.dart';

class ImageUploadCard extends StatelessWidget {
  const ImageUploadCard({
    Key key,
    @required this.currentInsertImage,
    @required StorageUploadTask uploadTask,
    @required this.currentFilePath,
    this.cropImage,
    this.startUploadImage,
    this.addingImageMarkdownToContent,
    this.currentUploadURLUpdater,
  })  : _uploadTask = uploadTask,
        super(key: key);

  final File currentInsertImage;
  final StorageUploadTask _uploadTask;
  final String currentFilePath;
  final Function cropImage;
  final Function startUploadImage;
  final Function addingImageMarkdownToContent;
  final Function currentUploadURLUpdater;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              padding: EdgeInsets.all(6),
              child: Image.file(
                currentInsertImage,
                fit: BoxFit.scaleDown,
              ),
              height: 100,
              width: 100,
            ),
          ),
          if (_uploadTask == null)
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: IconButton(
                icon: Icon(Icons.crop),
                onPressed: () {
                  cropImage();
                },
              ),
            ),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _uploadTask == null
                      ? IconButton(
                          icon: Icon(Icons.cloud_upload),
                          onPressed: () {
                            startUploadImage();
                          },
                        )
                      : ImageUploadEventsStreamBuilderButtomFunctionBar(
                          addingImageMarkdownToContent:
                              addingImageMarkdownToContent,
                          currentFilePath: currentFilePath,
                          currentUploadURLUpdater: currentUploadURLUpdater,
                          uploadTask: _uploadTask,
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
