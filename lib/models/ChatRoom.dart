import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

class ChatRoom {
  String id;
  List<User> members;
  List<Message> messages;
  DateTime createdAt;
  bool isGroup;
  String groupName;
  String groupPhotoUrl;

  ChatRoom({
    this.id,
    this.members,
    this.messages,
    this.createdAt,
    this.isGroup,
    this.groupName,
    this.groupPhotoUrl,
  });

  factory ChatRoom.fromMap(dynamic data) {
    return ChatRoom(
      id: data["id"],
      members: List<User>.from(
          (data["members"] as List<dynamic>).map((d) => User.fromMap(d))),
      messages: List<Message>.from(
          (data["messages"] as List<dynamic>).map((d) => Message.fromMap(d))),
      createdAt: Utils.getDateTime(data["createdAt"]),
      isGroup: data["isGroup"],
      groupName: data["groupName"],
      groupPhotoUrl: data["groupPhotoUrl"],
    );
  }

  Map<String, dynamic> toAddingMap() {
    return {
      "id": id,
      "members": members.map((m) => m.id).toList(),
      "messages": messages,
      "createdAt": createdAt,
      "isGroup": isGroup,
      "groupName": groupName,
      "groupPhotoUrl": groupPhotoUrl,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "members": members,
      "messages": messages,
      "createdAt": createdAt,
      "isGroup": isGroup,
      "groupName": groupName,
      "groupPhotoUrl": groupPhotoUrl,
    };
  }
}

class Message {
  String id;
  User author;
  int messageType;
  String content;
  DateTime createdAt;
  List<User> likeBy;
  List<User> readBy;

  Message({
    this.id,
    this.author,
    this.messageType,
    this.content,
    this.createdAt,
    this.likeBy,
    this.readBy,
  });

  factory Message.fromMap(dynamic data) {
    return Message(
      id: data["id"],
      author: data["author"],
      messageType: data["messageType"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      likeBy: data["likeBy"]?.cast<String>(),
      readBy: data["readBy"]?.cast<String>(),
    );
  }

  Map<String, dynamic> toAddingMap() {
    return {
      "id": id,
      "author": author.id,
      "messageType": messageType,
      "content": content,
      "createdAt": createdAt,
      "likeBy": likeBy,
      "readBy": readBy,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "author": author,
      "messageType": messageType,
      "content": content,
      "createdAt": createdAt,
      "likeBy": likeBy,
      "readBy": readBy,
    };
  }

  void replaceByAnother(Message another) {
    id = another.id;
    author = another.author;
    messageType = another.messageType;
    content = another.content;
    createdAt = another.createdAt;
    likeBy = another.likeBy;
    readBy = another.readBy;
  }
}
