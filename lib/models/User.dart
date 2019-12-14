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
  final int role; // 0 -> Admin, 1 -> NormalUser

  List<String> likePosts;
  List<String> likeComments;
  List<String> archivePosts;
  User({
    this.role,
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
    this.likePosts,
    this.archivePosts,
    this.likeComments,
  });

  factory User.fromMap(Map data) {
    if (data == null) {
      return null;
    }

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
      likePosts: data["likePosts"]?.cast<String>() ?? [],
      likeComments: data["likeComments"]?.cast<String>() ?? [],
      archivePosts: data["archivePosts"]?.cast<String>() ?? [],
      role: data["role"] ?? 1,
    );
  }

  bool get isAdmin {
    return role == 0;
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
      "likePosts": likePosts,
      "archivePosts": archivePosts,
      "likeComments": likeComments,
      "role": role,
    };
  }
}
