import 'package:quenc/utils/index.dart';

class User {
  String id;
  String domain;
  String email;
  String photoURL;
  String major;
  int role;
  int gender;
  bool emailVerified;
  DateTime createdAt;
  DateTime lastSeen;
  String dob;

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
    };
  }
}

/**
 * FireStore
 */

// class User {
//   String domain;
//   String email;
//   DateTime lastSeen;
//   int gender;
//   String photoURL;
//   String uid;
//   DateTime addedTime;
//   String currentRoom;
//   String major;
//   DateTime dob;
//   int role; // 0 -> Admin, 1 -> NormalUser

//   List<String> likePosts;
//   List<String> likeComments;
//   List<String> archivePosts;

//   User({
//     this.role,
//     this.domain,
//     this.email,
//     this.lastSeen,
//     this.photoURL,
//     this.uid,
//     this.addedTime,
//     this.currentRoom,
//     this.gender,
//     this.major,
//     this.dob,
//     this.likePosts,
//     this.archivePosts,
//     this.likeComments,
//   });

//   factory User.fromMap(Map data) {
//     if (data == null) {
//       return null;
//     }

//     return User(
//       domain: data["domain"],
//       email: data["email"],
//       lastSeen: DateTime.now(),
//       photoURL: data["photoURL"],
//       uid: data["uid"],
//       addedTime: data["addedTime"]?.toDate() ?? DateTime.now(),
//       currentRoom: data["currentRoom"],
//       gender: data["gender"],
//       major: data["major"],
//       dob: data["dob"]?.toDate() ?? DateTime.now(),
//       likePosts: data["likePosts"]?.cast<String>() ?? [],
//       likeComments: data["likeComments"]?.cast<String>() ?? [],
//       archivePosts: data["archivePosts"]?.cast<String>() ?? [],
//       role: data["role"] ?? 1,
//     );
//   }

//   bool get isAdmin {
//     return role == 0;
//   }

//   bool haveAttributesSet() {
//     List<dynamic> neededField = [gender, major, dob];
//     for (var ele in neededField) {
//       if (ele == null || ele.toString().isEmpty) {
//         return false;
//       }
//     }
//     return true;
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "domain": domain,
//       "email": email,
//       "lastSeen": lastSeen,
//       "photoURL": photoURL,
//       "uid": uid,
//       "addedTime": addedTime,
//       "currentRoom": currentRoom,
//       "gender": gender,
//       "major": major,
//       "dob": dob,
//       "likePosts": likePosts,
//       "archivePosts": archivePosts,
//       "likeComments": likeComments,
//       "role": role,
//     };
//   }
// }
