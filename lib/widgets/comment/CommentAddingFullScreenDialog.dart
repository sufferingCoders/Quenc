import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Comment.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/CommentService.dart';
import 'package:quenc/widgets/comment/CommentPreviewFullScreenDialog.dart';

class CommentAddingFullScreenDialog extends StatefulWidget {
  final String belongPost;
  CommentAddingFullScreenDialog({this.belongPost});

  @override
  _CommentAddingFullScreenDialogState createState() =>
      _CommentAddingFullScreenDialogState();
}

class _CommentAddingFullScreenDialogState
    extends State<CommentAddingFullScreenDialog> {
  final RegExp imageReg = RegExp(r"!\[.*?\]\(.*?\)");

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

  TextEditingController contentController;

  String content = "";

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
  }

  void _startUploadImage() {
    currentFilePath = "images/${DateTime.now()}.png";
    // _storage.ref().child(filePath).getDownloadURL().then((url) {
    //   setState(() {
    //     currentUploadURL = url as String;
    //   });
    // });

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
    var u = Provider.of<User>(context, listen: false);
    comment.author = u.uid;
    comment.authorGender = u.gender;
    comment.authorName = getDisplayNameFromEmail(u.email);
    comment.createdAt = DateTime.now();
    comment.updatedAt = DateTime.now();
    comment.belongPost = widget.belongPost;
    comment.likeCount = 0;

    String commentId =
        await Provider.of<CommentService>(context).addComment(comment);

    Navigator.of(context).pop();
  }

  String getDisplayNameFromEmail(String email) {
    List<String> emailParts = email.split("@");
    if (emailParts.length > 2) {
      return null;
    }

    String uni = "";

    switch (emailParts[1]) {
      case "qut.edu.au":
        uni = "Queensland University of Technology";
        break;
      case "uq.edu.au":
        uni = "University of Queensland";
        break;
      case "griffith.edu.au":
        uni = "Griffith University";
        break;
      default:
        uni = null;
    }

    return uni;
  }

  bool prepairCommentForPreview() {
    if (!_form.currentState.validate()) {
      return false;
    }

    _form.currentState.save();

    var u = Provider.of<User>(context, listen: false);
    comment.author = u.uid;
    comment.authorName = getDisplayNameFromEmail(u.email);
    comment.authorGender = u.gender;
    comment.createdAt = DateTime.now();
    comment.updatedAt = DateTime.now();
    comment.belongPost = widget.belongPost;
    comment.likeCount = 0;

    // need to init comment
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var nestScrollBody = NestedScrollView(
      headerSliverBuilder: (ctx, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text("回帖"),
            floating: true,
            snap: true,
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
        ];
      },
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                // autofocus: true,
                minLines: 40,
                maxLines: null,
                controller: contentController,

                // controller: TextEditingController.fromValue(TextEditingValue(
                //     text: content,
                //     selection: TextSelection.collapsed(
                //       offset: content.length - 1,
                //     ))),
                // scrollPadding: EdgeInsets.all(60),
                decoration: InputDecoration(
                  hintText: "點擊此處開始回帖... 請勿輸入過激內容",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                onSaved: (v) {
                  comment.content = v;
                },
                // onChanged: (v) {
                //   content = v;
                // },
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
      ),
    );

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

              // controller: TextEditingController.fromValue(TextEditingValue(
              //     text: content,
              //     selection: TextSelection.collapsed(
              //       offset: content.length - 1,
              //     ))),
              // scrollPadding: EdgeInsets.all(60),
              decoration: InputDecoration(
                hintText: "點擊此處開始回帖... 請勿輸入過激內容",
                hintStyle: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              onSaved: (v) {
                comment.content = v;
              },
              // onChanged: (v) {
              //   content = v;
              // },
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
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Wrap(
            children: <Widget>[
              if (currentInsertImage != null)
                Card(
                  // decoration: BoxDecoration(
                  //   border: Border.all(),
                  // ),
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
                              _cropImage();
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
                                      _startUploadImage();
                                    },
                                  )
                                : StreamBuilder(
                                    stream: _uploadTask.events,
                                    builder: (context, snapshot) {
                                      dynamic d = snapshot?.data;
                                      var event = d?.snapshot;

                                      double progressPercent = event != null
                                          ? event.bytesTransferred /
                                              event.totalByteCount
                                          : 0;

                                      if (_uploadTask.isComplete) {
                                        _storage
                                            .ref()
                                            .child(currentFilePath)
                                            .getDownloadURL()
                                            .then((url) {
                                          String urlString = url as String;

                                          if (currentUploadURL == urlString) {
                                            return;
                                          }

                                          setState(() {
                                            currentUploadURL = urlString;
                                          });
                                        });
                                      }

                                      return _uploadTask.isComplete
                                          ? ListTile(
                                              title: Text("上傳成功"),
                                              trailing: FlatButton(
                                                  child: Text(
                                                    "插入",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    String addingImageMd =
                                                        "\n" +
                                                            "![圖片載入中...](" +
                                                            currentUploadURL +
                                                            ")" +
                                                            "\n";

                                                    var cursorPosition =
                                                        contentController
                                                            .selection;
                                                    var idx =
                                                        cursorPosition.start;

                                                    if (idx != -1) {
                                                      contentController
                                                          .text = contentController
                                                              .text
                                                              .substring(
                                                                  0, idx) +
                                                          addingImageMd +
                                                          contentController.text
                                                              .substring(
                                                                  idx,
                                                                  contentController
                                                                      .text
                                                                      .length);
                                                    } else {
                                                      contentController.text +=
                                                          addingImageMd;
                                                    }

                                                    if (cursorPosition.start >
                                                        contentController
                                                            .text.length) {
                                                      cursorPosition =
                                                          TextSelection
                                                              .fromPosition(
                                                        TextPosition(
                                                            offset:
                                                                contentController
                                                                    .text
                                                                    .length),
                                                      );

                                                      contentController
                                                              .selection =
                                                          cursorPosition;
                                                    } else {
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset: cursorPosition
                                                                      .start +
                                                                  addingImageMd
                                                                      .length));
                                                    }
                                                    setState(() {
                                                      _uploadTask = null;
                                                      currentFilePath = null;
                                                      currentUploadURL = null;
                                                      currentInsertImage = null;
                                                    });

                                                    return;

                                                    // var cursorPosition =
                                                    //     contentController
                                                    //         .selection;
                                                    // var idx =
                                                    //     cursorPosition.start;

                                                    // if (idx != -1) {
                                                    //   contentController
                                                    //       .text = contentController
                                                    //           .text
                                                    //           .substring(0, idx) +
                                                    //       addingImageMd +
                                                    //       contentController.text
                                                    //           .substring(
                                                    //               idx,
                                                    //               contentController
                                                    //                   .text
                                                    //                   .length);
                                                    // } else {
                                                    //   contentController.text +=
                                                    //       addingImageMd;
                                                    // }

                                                    // if (cursorPosition.start >
                                                    //     contentController
                                                    //         .text.length) {
                                                    //   cursorPosition =
                                                    //       TextSelection
                                                    //           .fromPosition(
                                                    //     TextPosition(
                                                    //         offset:
                                                    //             contentController
                                                    //                 .text.length),
                                                    //   );

                                                    //   contentController
                                                    //           .selection =
                                                    //       cursorPosition;
                                                    // } else {
                                                    //   // contentController
                                                    //   //         .selection =
                                                    //   //     cursorPosition;
                                                    //   TextSelection.fromPosition(
                                                    //       TextPosition(
                                                    //           offset: cursorPosition
                                                    //                   .start +
                                                    //               addingImageMd
                                                    //                   .length));
                                                  }

                                                  // contentController.selection =
                                                  //     TextSelection.collapsed(
                                                  //         offset: contentController.text.length );

                                                  // _uploadTask = null;
                                                  // currentFilePath = null;
                                                  // currentUploadURL = null;
                                                  // currentInsertImage = null;
                                                  // },
                                                  ),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                  // if (_uploadTask.isPaused)
                                                  //   FlatButton(
                                                  //     child: Icon(Icons.play_arrow, size: 50),
                                                  //     onPressed: _uploadTask.resume,
                                                  //   ),
                                                  // if (_uploadTask.isInProgress)
                                                  //   FlatButton(
                                                  //     child: Icon(Icons.pause, size: 50),
                                                  //     onPressed: _uploadTask.pause,
                                                  //   ),
                                                  Text(
                                                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                                                  ),
                                                  LinearProgressIndicator(
                                                      value: progressPercent),

                                                  Text(
                                                    '上傳中',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      // height: 2,
                                                    ),
                                                  ),
                                                ]);
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
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
                      _pickImage(ImageSource.camera);
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
                      _pickImage(ImageSource.gallery);
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
                      bool ok = prepairCommentForPreview();
                      if (ok) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // final dialog = PostPreviewFullScreenDialog(
                              //   // inputText: contentController.text,
                              //   post: post,
                              // );
                              // return dialog;

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
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
