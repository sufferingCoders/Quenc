class User {
  final String displayName;
  final String email;
  final DateTime lastSeen;
  final String gender;
  final String photoURL;
  final String uid;
  final DateTime addedTime;
  final String currentRoom;
  final String major;
  final DateTime dob;
  List<String> posts;
  List<String> comments;

  User({
    this.displayName,
    this.email,
    this.lastSeen,
    this.photoURL,
    this.uid,
    this.addedTime,
    this.currentRoom,
    this.gender,
    this.major,
    this.dob,
  });

  factory User.fromMap(Map data) {
    return User(
      displayName: data["displayName"] ?? "",
      email: data["email"] ?? "",
      lastSeen: DateTime.now(),
      photoURL: data["photoURL"] ?? "",
      uid: data["uid"] ?? "",
      addedTime: data["addedTime"]?.toDate() ?? DateTime.now(),
      currentRoom: data["currentRoom"] ?? null,
      gender: data["gender"] ?? "",
      major: data["major"] ?? "",
      dob: data["dob"]?.toDate() ?? DateTime.now(),
    );
  }

  bool haveAttributesSet() {
    List<dynamic> neededField = [gender, major, dob];
    for (var ele in neededField) {
      if (ele == null || ele.toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      "displayName": displayName,
      "email": email,
      "lastSeen": lastSeen,
      "photoURL": photoURL,
      "uid": uid,
      "addedTime": addedTime,
      "currentRoom": currentRoom,
      "gender": gender,
      "major": major,
      "dob": dob,
    };
  }
}
