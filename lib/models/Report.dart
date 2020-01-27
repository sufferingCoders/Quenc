import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

enum ReportTarget {
  Comment,
  Post,
  Chat,
}

/// Report Schema for saving in the Firestore
class Report {
  String id;
  String content;
  User author;
  String previewText;
  String previewPhoto;
  int reportTarget;
  DateTime createdAt;
  String reportId;
  bool solve;
  Map<String, dynamic> reportObject;

  Report({
    this.content,
    this.id,
    this.author,
    this.createdAt,
    this.previewPhoto,
    this.previewText,
    this.reportTarget,
    this.reportId,
    this.solve,
    this.reportObject,
  });

  // Report Code
  static const List<String> reportTypeCodeList = [
    "其他", // 0
    "謾罵他人", // 1
    "惡意洗版", // 2
    "惡意洩漏他人資料", // 3
    "包含色情, 血腥, 暴力內容", // 4
    "廣告和宣傳內容", // 5
  ];

  // From int to ReportTarget
  static ReportTarget reportTargetIntToEnum(int target) {
    switch (target) {
      case 0:
        return ReportTarget.Post;
        break;
      case 1:
        return ReportTarget.Comment;
        break;
      case 2:
        return ReportTarget.Chat;
  
      default:
        return null;
    }
  }

  // From ReportTarget to int
  static int reportTargetEnumToInt(ReportTarget target) {
    switch (target) {
      case ReportTarget.Post:
        return 0;
        break;
      case ReportTarget.Comment:
        return 1;
        break;
      case ReportTarget.Chat:
        return 2;

      default:
        return null;
    }
  }

  static String reportTypeCodeToString(int code) {
    if (code > reportTypeCodeList.length) {
      return null;
    }
    return reportTypeCodeList[code];
  }

  factory Report.fromMap(dynamic data) {
    return Report(
      author: User.fromMap(data["author"]),
      id: data["_id"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      previewPhoto: data["previewPhoto"],
      previewText: data["previewText"],
      reportTarget: data["reportTarget"],
      reportId: data["reportId"],
      solve: data["solve"],
      reportObject: data["reportObject"],
    );
  }

  Map<String, dynamic> toAddingMap() {
    return {
      "content": content,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "reportTarget": reportTarget,
      "reportId": reportId,
      "solve": solve,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "author": author?.toMap(),
      "_id": id,
      "content": content,
      "createdAt": createdAt,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "reportTarget": reportTarget,
      "reportId": reportId,
      "solve": solve,
      "reportObject": reportObject,
    };
  }
}
