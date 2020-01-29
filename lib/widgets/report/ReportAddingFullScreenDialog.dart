import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quenc/models/Report.dart';
import 'package:quenc/providers/ReportGolangService.dart';
import 'package:quenc/providers/UserGolangService.dart';
import 'package:quenc/utils/index.dart';
import 'package:quenc/widgets/common/PostAddingBottomNavigationBar.dart';
import 'package:quenc/widgets/report/ReportPreviewFullScreenDialog.dart';

class ReportAddingFullScreenDialog extends StatefulWidget {
  // Adding report class here
  final ReportTarget target;
  final String reportId;

  ReportAddingFullScreenDialog({
    @required this.reportId,
    @required this.target,
  });

  @override
  _ReportAddingFullScreenDialogState createState() =>
      _ReportAddingFullScreenDialogState();
}

class _ReportAddingFullScreenDialogState
    extends State<ReportAddingFullScreenDialog> {
  Report report = Report();

  final _form = GlobalKey<FormState>();

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://quenc-hlc.appspot.com");

  StorageUploadTask _uploadTask;

  String currentUploadURL;

  String currentFilePath;

  File currentInsertImage;

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

    addReport();
  }

  Future<void> _pickImage(ImageSource source) async {
    currentInsertImage = null;
    currentUploadURL = null;
    _uploadTask = null;
    currentFilePath = null;
    File selected = await ImagePicker.pickImage(
      source: source,
      maxWidth: 1936,
      maxHeight: 1936,
      imageQuality: 40,
    );

    print("File Size is ${selected?.lengthSync()}");

    setState(() {
      currentInsertImage = selected;
    });
  }

  void reportCompleteFields() {
    var u = Provider.of<UserGolangService>(context, listen: false).user;
    report.reportId = widget.reportId;
    report.createdAt = DateTime.now();
    report.reportTarget = Report.reportTargetEnumToInt(widget.target);
    report.previewPhoto = Utils.getFirstImageURLFromMarkdown(report.content);
    report.previewText = Utils.getPreviewTextFromContent(report.content);
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

  void addReport() async {
    reportCompleteFields();
    await Provider.of<ReportGolangService>(context).addReport(report);
    Navigator.of(context).pop();
  }

  bool prepairReportForPreview() {
    if (!_form.currentState.validate()) {
      return false;
    }
    _form.currentState.save();
    reportCompleteFields();
    return true;
  }

  void previewButtonPress() {
    bool ok = prepairReportForPreview();
    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            final dialog = ReportPreviweFullScreenDialog(
              report: report,
            );
            return dialog;
          },
          fullscreenDialog: true,
        ),
      );
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

  void currentUploadURLUpdater(dynamic url) {
    String urlString = url as String;

    if (currentUploadURL == urlString) {
      return;
    }

    setState(() {
      currentUploadURL = url as String;
    });
  }

  List<DropdownMenuItem<int>> reportTypesItems() {
    List<DropdownMenuItem<int>> items = [];
    for (var i = 0; i < Report.reportTypeCodeList.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(Report.reportTypeCodeList[i]),
        value: i,
      ));
    }
    return items;
  }

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("舉報"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _submit(context);
            },
          )
        ],
      ),
      bottomNavigationBar: PostAddingBottomNavigationBar(
        currentFilePath: currentFilePath,
        currentInsertImage: currentInsertImage,
        uploadTask: _uploadTask,
        addingImageMarkdownToContent: addingImageMarkdownToContent,
        cropImage: _cropImage,
        currentUploadURLUpdater: currentUploadURLUpdater,
        pickImage: _pickImage,
        startUploadImage: _startUploadImage,
        previewButtonPress: previewButtonPress,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Flexible(
              //       flex: 1,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("分類:"),
              //       ),
              //     ),
              //     Flexible(
              //       flex: 2,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: DropdownButton<int>(
              //           value: report.reportType,
              //           onChanged: (v) {
              //             setState(() {
              //               report.reportType = v;
              //             });
              //           },
              //           items: reportTypesItems(),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  minLines: 40,
                  controller: contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "點擊此開始編輯\n\n請簡單描述檢舉此文章/評論的原因\n\n再附上螢幕截圖",
                    border: InputBorder.none,
                  ),
                  onSaved: (v) {
                    report.content = v;
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "請輸入內容";
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
