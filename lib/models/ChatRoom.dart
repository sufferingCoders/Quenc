import 'package:quenc/models/User.dart';
import 'package:quenc/utils/index.dart';

/// ChatRoom stores messages and other chatting related info
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

  // Return the User of a member in this chatRoom
  User getMemberById(String id) {
    return members.firstWhere((m) => m.id == id);
  }

  factory ChatRoom.fromMap(dynamic data) {
    ChatRoom c = ChatRoom(
      id: data["_id"],
      members: List<User>.from(
          (data["members"] as List<dynamic>).map((d) => User.fromMap(d))),
      createdAt: Utils.getDateTime(data["createdAt"]),
      isGroup: data["isGroup"],
      groupName: data["groupName"],
      groupPhotoUrl: data["groupPhotoUrl"],
    );

    c.messages = List<Message>.from((data["messages"] as List<dynamic>)
        .map((d) => Message.fromMapAndRoom(d, c)));

    return c;
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

enum MessageType {
  AdminMessage,
  Text,
  Photo,
}

/// Message contain the info showing in the chat list
class Message {
  String id;
  User author;
  int messageType; // 0 is Admin, 1 is Text, 2 is Photo
  String content;
  DateTime createdAt;
  List<String> likeBy;
  List<String> readBy;

  Message({
    this.id,
    this.author,
    this.messageType,
    this.content,
    this.createdAt,
    this.likeBy,
    this.readBy,
  });

  /// Get the enum of message type
  MessageType messageTypeIntToText(int i) {
    switch (i) {
      case 0:
        return MessageType.AdminMessage;
        break;
      case 1:
        return MessageType.Text;
        break;
      case 2:
        return MessageType.Photo;
        break;
      default:
        return null;
    }
  }

  factory Message.fromMapAndRoom(dynamic data, ChatRoom c) {
    return Message(
      id: data["_id"],
      author: c.getMemberById(data["author"]),
      messageType: data["messageType"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      likeBy: data["likeBy"]?.cast<String>(),
      readBy: data["readBy"]?.cast<String>(),
    );
  }

  factory Message.fromMap(
    dynamic data,
  ) {
    return Message(
      id: data["id"],
      author: User(id: data["author"]),
      messageType: data["messageType"],
      content: data["content"],
      createdAt: Utils.getDateTime(data["createdAt"]),
      likeBy: data["likeBy"]?.cast<String>(),
      readBy: data["readBy"]?.cast<String>(),
    );
  }

  // Adding map will be sent to backend to add a new chat room
  Map<String, dynamic> toAddingMap() {
    return {
      "id": id,
      "author": author.id,
      "messageType": messageType,
      "content": content,
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

  // replace this message by another, but not affect the reference address
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
