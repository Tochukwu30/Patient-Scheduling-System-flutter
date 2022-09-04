import 'user.dart';

class Chat {
  final int id;
  final DateTime created;
  final DateTime updated;
  final String? name;
  final String threadType;
  final List<User> users;

  Chat({
    required this.id,
    required this.created,
    required this.updated,
    required this.name,
    required this.threadType,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json["id"],
      created: DateTime.parse(json["created"]),
      updated: DateTime.parse(json["updated"]),
      name: json["name"],
      threadType: json["thread_type"],
      users:
          List<User>.from(json["users"].map((model) => User.fromJson(model))),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> chat = {};
    chat["id"] = id;
    chat["created"] = created;
    chat["updated"] = updated;
    chat["name"] = name;
    chat["thread_type"] = threadType;
    chat["users"] = List<Map<String, dynamic>>.from(
      (users.map(
        (e) => e.toJson(),
      )),
    );
    return chat;
  }
}

class ChatsListResult {
  // Class modelling response form getChats request

  final String? next;
  final String? previous;
  final List<Chat> results;

  ChatsListResult({
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ChatsListResult.fromJson(Map<String, dynamic> json) {
    return ChatsListResult(
      next: json["next"],
      previous: json["previous"],
      results: json["results"].length != 0
          ? List<Chat>.from(
              json["results"].map((model) => Chat.fromJson(model)))
          : <Chat>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> chatsList = <String, dynamic>{};
    chatsList["next"] = next;
    chatsList["previous"] = previous;
    chatsList["results"] = List<Map<String, dynamic>>.from(results.map(
      (e) => e.toJson(),
    ));
    return chatsList;
  }
}

// Class modelling messages
class Message {
  final int id;
  final DateTime? created;
  final DateTime? updated;
  final int sender;
  final String text;
  final int? thread;

  Message({
    required this.id,
    this.created,
    this.updated,
    required this.sender,
    required this.text,
    this.thread,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"] ?? 0,
      created: DateTime.parse(json["created"]),
      updated: DateTime.parse(json["updated"]),
      sender: json["sender"],
      text: json["text"],
      thread: json["thread"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> message = {};
    message["id"] = id;
    message["created"] = created;
    message["updated"] = updated;
    message["sender"] = sender;
    message["text"] = text;
    message["thread"] = thread;

    return message;
  }
}

class MessagesListResult {
  // Class modelling response form getMessages request

  final String? next;
  final String? previous;
  final List<Message> results;

  MessagesListResult({
    required this.next,
    required this.previous,
    required this.results,
  });

  factory MessagesListResult.fromJson(Map<String, dynamic> json) {
    return MessagesListResult(
      next: json["next"],
      previous: json["previous"],
      results: json["results"].length != 0
          ? List<Message>.from(
              json["results"].map((model) => Message.fromJson(model)))
          : <Message>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> messagesList = <String, dynamic>{};
    messagesList["next"] = next;
    messagesList["previous"] = previous;
    messagesList["results"] = List<Map<String, dynamic>>.from(results.map(
      (e) => e.toJson(),
    ));
    return messagesList;
  }
}
