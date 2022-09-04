import 'package:flutter/material.dart';
import 'package:pss/models/chat.dart';
import 'package:pss/models/user.dart';
import 'package:pss/pages/chat.dart';

class ChatsListWidget extends StatefulWidget {
  final List<Chat> chats;
  final Map<String, dynamic> token;
  const ChatsListWidget({
    Key? key,
    required this.chats,
    required this.token,
  }) : super(key: key);

  @override
  State<ChatsListWidget> createState() => _ChatsListWidgetState();
}

class _ChatsListWidgetState extends State<ChatsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.chats.length,
          itemBuilder: (BuildContext context, int index) {
            Chat chat = widget.chats[index];
            User user = chat.users.firstWhere(
              (element) => element.id != widget.token["id"],
            );
            return InkWell(
              // Make chats clickable
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(user: user)));
              },
              child: Ink(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 10.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ]);
  }
}
