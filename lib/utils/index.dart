class Utils {
  static final RegExp imageReg = RegExp(r"!\[.*?\]\(.*?\)");

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
}
