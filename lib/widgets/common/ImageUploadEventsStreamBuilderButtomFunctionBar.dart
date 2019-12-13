import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quenc/widgets/common/ImageUploadSuccessfulInsertListTile.dart';
import 'package:quenc/widgets/common/ImageUploadingProgressBar.dart';

class ImageUploadEventsStreamBuilderButtomFunctionBar extends StatelessWidget {
  final StorageUploadTask uploadTask;
  final String currentFilePath;
  final Function currentUploadURLUpdater;
  final Function addingImageMarkdownToContent;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://quenc-hlc.appspot.com");

  ImageUploadEventsStreamBuilderButtomFunctionBar({
    this.addingImageMarkdownToContent,
    this.currentUploadURLUpdater,
    this.uploadTask,
    this.currentFilePath,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: uploadTask.events,
      builder: (context, snapshot) {
        dynamic d = snapshot?.data;
        var event = d?.snapshot;

        double progressPercent =
            event != null ? event.bytesTransferred / event.totalByteCount : 0;

        if (uploadTask.isComplete) {
          _storage
              .ref()
              .child(currentFilePath)
              .getDownloadURL()
              .then(currentUploadURLUpdater);
        }

        return uploadTask.isComplete
            ? ImageUploadSuccessfulInsertListTile(
                addingImageMarkdownToContent,
              )
            : ImageUploadingProgressBar(
                progressPercent: progressPercent,
              );
      },
    );
  }
}
