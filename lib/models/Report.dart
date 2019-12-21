enum ReportTarget {
  Comment,
  Post,
}

class Report {
  // Report Schema for saving in the Firestore

  String id;
  String content;
  String author;
  String authorDomain;
  int authorGender;
  String previewText;
  String previewPhoto;
  int reportTarget;
  int reportType;
  DateTime createdAt;
  String reportId;
  bool solve;

  Report({
    this.content,
    this.id,
    this.author,
    this.reportType,
    this.createdAt,
    this.authorDomain,
    this.authorGender,
    this.previewPhoto,
    this.previewText,
    this.reportTarget,
    this.reportId,
    this.solve,
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

  factory Report.fromMap(Map data) {
    return Report(
      author: data["author"],
      id: data["id"],
      content: data["content"],
      reportType: data["reportType"],
      createdAt: data["createdAt"].toDate(),
      authorDomain: data["authorDomain"],
      authorGender: data["authorGender"],
      previewPhoto: data["previewPhoto"],
      previewText: data["previewText"],
      reportTarget: data["reportTarget"],
      reportId: data["reportId"],
      solve: data["solve"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "author": author,
      "id": id,
      "content": content,
      "reportType": reportType,
      "createdAt": createdAt,
      "authorDomain": authorDomain,
      "authorGender": authorGender,
      "previewPhoto": previewPhoto,
      "previewText": previewText,
      "reportTarget": reportTarget,
      "reportId": reportId,
      "solve": solve,
    };
  }
}
