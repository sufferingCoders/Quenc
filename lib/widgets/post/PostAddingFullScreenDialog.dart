import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Post.dart';
import 'package:quenc/models/User.dart';
import 'package:quenc/providers/PostGolangService.dart';
import 'package:quenc/providers/PostService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/common/PostAddingBottomNavigationBar.dart';
import 'package:quenc/widgets/common/ScrollHideSliverAppBar.dart';
import 'package:quenc/widgets/post/PostEditingForm.dart';
import 'package:quenc/widgets/post/PostPreviewFullScreenDialog.dart';

enum PostMode {
  Adding,
  Editing,
}

// This one should be able for editing and addding
class PostAddingFullScreenDialog extends StatefulWidget {
  final Post post;
  PostMode mode;

  PostAddingFullScreenDialog({this.post}) {
    if (this.post == null) {
      mode = PostMode.Adding;
    } else {
      mode = PostMode.Editing;
    }
  }

  @override
  _PostAddingFullScreenDialogState createState() =>
      _PostAddingFullScreenDialogState();
}

class _PostAddingFullScreenDialogState
    extends State<PostAddingFullScreenDialog> {
  final _form = GlobalKey<FormState>();
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://quenc-hlc.appspot.com");

  StorageUploadTask _uploadTask;
  String currentUploadURL;
  String currentFilePath;

  TextEditingController contentController = TextEditingController();

  void _startUploadImage() {
    currentFilePath = "images/${DateTime.now()}.png";
    setState(() {
      _uploadTask =
          _storage.ref().child(currentFilePath).putFile(currentInsertImage);
    });
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

  File currentInsertImage;

  Post post;

  @override
  void initState() {
    if (widget.mode == PostMode.Adding) {
      post = Post(
        anonymous: false,
        title: "",
        content: "",
      );
    } else {
      post = widget.post;
    }

    // TODO: implement initState
    super.initState();
    contentController.text = post.content;
  }

  void _submit(BuildContext ctx) {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    switch (widget.mode) {
      case PostMode.Adding:
        addPost(context);
        break;
      case PostMode.Editing:
        updatePost(context);
        break;
      default:
        print("Not supported mode performed");
        break;
    }
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

    // contentController.selection =
    //     TextSelection.collapsed(
    //         offset: contentController.text.length );
    setState(() {
      _uploadTask = null;
      currentFilePath = null;
      currentUploadURL = null;
      currentInsertImage = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      currentInsertImage = selected;
    });
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

  void postCompleteFields({initCreatedAt = true}) {
    var u = Provider.of<UserGolangService>(context, listen: false).user;
    post.author = u;
    post.previewPhoto = Utils.getFirstImageURLFromMarkdown(post.content);
    post.updatedAt = DateTime.now();
    post.previewText = Utils.getPreviewTextFromContent(post.content);
    if (initCreatedAt) {
      post.createdAt = DateTime.now();
    }
  }

  void addPost(BuildContext ctx) async {
    postCompleteFields();
    await Provider.of<PostGolangService>(ctx, listen: false).addPost(post);
    Navigator.of(ctx).pop();
  }

  void updatePost(BuildContext ctx) async {
    postCompleteFields(initCreatedAt: false);
    await Provider.of<PostGolangService>(ctx, listen: false).updatePost(
      post.id,
      post.toAddingMap(),
    );
    Navigator.of(ctx).pop();
  }

  bool prepairPostForPreview() {
    if (!_form.currentState.validate()) {
      return false;
    }
    _form.currentState.save();
    postCompleteFields();
    return true;
  }

  void previewButtonPress() {
    bool ok = prepairPostForPreview();
    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            final dialog = PostPreviewFullScreenDialog(
              // inputText: contentController.text,
              post: post,
            );
            return dialog;
          },
          fullscreenDialog: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) {
          return <Widget>[
            ScrollHideSliverAppBar(
              titleText: widget.mode == PostMode.Adding ? "新增文章" : "編輯文章",
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _submit(context);
                  },
                )
              ],
            ),
          ];
        },
        body: PostEditingForm(
          form: _form,
          post: post,
          contentController: contentController,
        ),
      ),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: PostAddingBottomNavigationBar(
        addingImageMarkdownToContent: addingImageMarkdownToContent,
        cropImage: _cropImage,
        currentUploadURLUpdater: currentUploadURLUpdater,
        startUploadImage: _startUploadImage,
        pickImage: _pickImage,
        currentInsertImage: currentInsertImage,
        uploadTask: _uploadTask,
        currentFilePath: currentFilePath,
        previewButtonPress: previewButtonPress,
      ),
    );
  }
}
