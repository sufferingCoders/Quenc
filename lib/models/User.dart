import 'package:quenc/utils/index.dart';

class User {
  String id;
  String domain;
  String email;
  String photoURL;
  String major;
  String dob;
  String name;
  String randomChatRoom;
  int role;
  int gender;
  bool emailVerified;
  DateTime createdAt;
  DateTime lastSeen;

  List<String> likePosts;
  List<String> chatRooms;
  List<String> likeComments;
  List<String> friends;
  List<String> savedPosts;

  // Role: 0 -> Admin, 1 -> NormalUser
  User({
    this.id,
    this.domain,
    this.email,
    this.photoURL,
    this.major,
    this.role,
    this.gender,
    this.emailVerified,
    this.createdAt,
    this.lastSeen,
    this.dob,
    this.chatRooms,
    this.friends,
    this.savedPosts,
    this.likePosts,
    this.likeComments,
    this.name,
    this.randomChatRoom,
  });

  factory User.fromMap(dynamic data) {
    if (data == null) {
      return null;
    }

    return User(
      id: data["_id"],
      domain: data["domain"],
      email: data["email"],
      photoURL: data["photoURL"],
      major: data["major"],
      role: data["role"],
      gender: data["gender"] == -1 ? null : data["gender"],
      emailVerified: data["emailVerified"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      lastSeen: Utils.getDateTime(data["lastSeen"]),
      dob: data["dob"],
      chatRooms: data["chatRooms"]?.cast<String>(),
      friends: data["friends"]?.cast<String>(),
      savedPosts: data["savedPosts"]?.cast<String>(),
      likePosts: data["likePosts"]?.cast<String>(),
      likeComments: data["likeComments"]?.cast<String>(),
      name: data["name"],
      randomChatRoom: data["randomChatRoom"],
    );
  }

  /// Check the Authority
  bool get isAdmin {
    return role == 0;
  }

  /// To see if the user is already in a random chat room.
  bool get hasRandomChatRoom {
    return randomChatRoom != null;
  }

  /// Does the user have the required attributes set.
  bool haveAttributesSet() {
    List<dynamic> neededField = [gender, major, dob, name];
    for (var ele in neededField) {
      if (ele == null || ele.toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "domain": domain,
      "email": email,
      "photoURL": photoURL,
      "major": major,
      "role": role,
      "gender": gender,
      "emailVerified": emailVerified,
      "lastSeen": lastSeen,
      "dob": dob,
      "chatRooms": chatRooms,
      "friends": friends,
      "savedPosts": savedPosts,
      "likePosts": likePosts,
      "likeComments": likeComments,
      "name": name,
      "randomChatRoom": randomChatRoom,
    };
  }
}
