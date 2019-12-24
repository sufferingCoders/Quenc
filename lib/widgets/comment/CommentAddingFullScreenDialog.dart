import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/comment/CommentPreviewFullScreenDialog.dart';
import 'package:quenc/widgets/common/PostAddingBottomNavigationBar.dart';

class CommentAddingFullScreenDialog extends StatefulWidget {
  final String belongPost;
  CommentAddingFullScreenDialog({this.belongPost});

  @override
  _CommentAddingFullScreenDialogState createState() =>
      _CommentAddingFullScreenDialogState();
}

class _CommentAddingFullScreenDialogState
    extends State<CommentAddingFullScreenDialog> {
  final _form = GlobalKey<FormState>();

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://quenc-hlc.appspot.com");

  File currentInsertImage;

  Comment comment = Comment(
    content: "",
  );

  StorageUploadTask _uploadTask;

  String currentUploadURL;

  String currentFilePath;

  TextEditingController contentController = TextEditingController();

  String content = "";

  void _startUploadImage() {
    currentFilePath = "images/${DateTime.now()}.png";

    setState(() {
      _uploadTask =
          _storage.ref().child(currentFilePath).putFile(currentInsertImage);
    });
  }

  void _submit(BuildContext ctx) {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();
    addComment(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      currentInsertImage = selected;
    });

    // Uploading the image here
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: currentInsertImage.path,
      compressFormat: ImageCompressFormat.png,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
    );

    setState(() {
      currentInsertImage = cropped ?? currentInsertImage;
    });
  }

  void addComment(BuildContext ctx) async {
    commentFieldComplete();
    await Provider.of<CommentGolangService>(context).addComment(comment);
    Navigator.of(context).pop();
  }

  void commentFieldComplete() {
    var u = Provider.of<User>(context, listen: false);
    comment.author = u;
    comment.createdAt = DateTime.now();
    comment.updatedAt = DateTime.now();
    comment.belongPost = widget.belongPost;
  }

  bool prepairCommentForPreview() {
    if (!_form.currentState.validate()) {
      return false;
    }

    _form.currentState.save();

    commentFieldComplete();

    // need to init comment
    return true;
  }

  void currentUploadURLUpdater(dynamic url) {
    String urlString = url as String;

    if (currentUploadURL == urlString) {
      return;
    }

    setState(() {
      currentUploadURL = url as String;
    });
  }

  void addingImageMarkdownToContent() {
    String addingImageMd =
        "\n" + "![圖片載入中...](" + currentUploadURL + ")" + "\n";

    var cursorPosition = contentController.selection;
    var idx = cursorPosition.start;

    if (idx != -1) {
      contentController.text = contentController.text.substring(0, idx) +
          addingImageMd +
          contentController.text.substring(idx, contentController.text.length);
    } else {
      contentController.text += addingImageMd;
    }

    if (cursorPosition.start > contentController.text.length) {
      cursorPosition = TextSelection.fromPosition(
        TextPosition(offset: contentController.text.length),
      );

      contentController.selection = cursorPosition;
    } else {
      contentController.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPosition.start + addingImageMd.length));
    }

    setState(() {
      _uploadTask = null;
      currentFilePath = null;
      currentUploadURL = null;
      currentInsertImage = null;
    });
  }

  void previewButtonPress() {
    bool ok = prepairCommentForPreview();
    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CommentPreviewFullScreenDialog(
              comment: comment,
            );
          },
          fullscreenDialog: true,
        ),
      );
    } else {
      print("Not ok for preview");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBarBody = Form(
      key: _form,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              autofocus: true,
              minLines: 10,
              maxLines: null,
              controller: contentController,
              decoration: InputDecoration(
                hintText: "點擊此處開始回帖... 請勿輸入過激內容",
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              onSaved: (v) {
                comment.content = v;
              },
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "請輸入內容";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("回文"),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.send,
                ),
                onPressed: () => _submit(context),
              )),
        ],
      ),
      body: appBarBody,
      bottomNavigationBar: PostAddingBottomNavigationBar(
        currentFilePath: currentFilePath,
        currentInsertImage: currentInsertImage,
        uploadTask: _uploadTask,
        addingImageMarkdownToContent: addingImageMarkdownToContent,
        cropImage: _cropImage,
        currentUploadURLUpdater: currentUploadURLUpdater,
        pickImage: _pickImage,
        previewButtonPress: previewButtonPress,
        startUploadImage: _startUploadImage,
      ),
    );
  }
}
