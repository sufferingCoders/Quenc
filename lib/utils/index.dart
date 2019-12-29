class Utils {
  static final RegExp imageReg = RegExp(r"!\[.*?\]\(.*?\)");

  static String getDisplayNameFromDomain(String domain) {
    String uni;

    switch (domain) {
      case "qut.edu.au":
        uni = "昆士蘭理工";
        break;
      case "uq.edu.au":
        uni = "昆士蘭大學";
        break;
      case "griffith.edu.au":
        uni = "格里菲斯";
        break;
      default:
        uni = "UNKNOWN";
    }

    return uni;
  }

  static String getDomainFromEmail(String email) {
    List<String> emailParts = email.split("@");
    if (emailParts.length > 2) {
      return null;
    }

    return emailParts[1];
  }

  static String getDisplayNameFromEmail(String email) {
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

  static dynamic jsonEncodable(dynamic data) {
    if (data is DateTime) {
      return data.toIso8601String();
    }
    return "";
  }

  static String getFirstImageURLFromMarkdown(String content) {
    var match = imageReg.firstMatch(content);
    String firstImageUrl = content.substring(match.start, match.end);
    // print(firstImageUrl);
    int idxStart = firstImageUrl.indexOf("(");
    String retrievedURL =
        firstImageUrl.substring(idxStart + 1, firstImageUrl.length - 1);
    return retrievedURL;
  }

  static String getPreviewTextFromContent(String content) {
    String preview = "";

    List<String> sentences = content.split("\n");

    for (String s in sentences) {
      if (!imageReg.hasMatch(s)) {
        return s;
      }
    }

    return preview;
  }

  static DateTime getDateTime(dynamic time) {
    if (time is DateTime) {
      return time;
    } else if (time is String) {
      if (time?.isNotEmpty == true) {
        if (time.length > 23) {
          String tempTime = time.substring(0, 23) + "Z";
          return DateTime.tryParse(tempTime);
        }
        return DateTime.tryParse(time);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
