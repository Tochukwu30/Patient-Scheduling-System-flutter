import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/models/chat.dart';
import 'package:pss/service/pss_chat_api.dart';
import 'package:pss/widgets/appdrawer.dart';
import 'package:pss/widgets/chats.dart';

import '../service/pss_api.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _controller = ScrollController();
  List<Chat> chatsList = [];
  late String? next;
  late Map<String, dynamic> token;
  late Future<bool> _future;

  Future<bool> fetchChats() async {
    ApiResponse result = await getChatList();
    if (result.hasData()) {
      final chatsResult = result.Data as ChatsListResult;
      setState(() {
        chatsList.addAll(chatsResult.results);
        next = chatsResult.next;
      });
      return true;
    }
    return false;
  }

  void getNext() async {
    ApiResponse result = await getNextChats(next: next!);
    if (result.hasData()) {
      final chatsResult = result.Data as ChatsListResult;
      setState(() {
        chatsList.addAll(chatsResult.results);
        next = chatsResult.next;
      });
    }
  }

  void getToken() async {
    Map<String, dynamic> token_ = await SessionManager().get("token");
    setState(() {
      token = token_;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getToken();
    super.initState();
    _future = fetchChats();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (next != null) {
          getNext();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: const Text("Chats"),
      ),
      endDrawer: const PssDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<bool>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    bool response = snapshot.data!;
                    if (response) {
                      return ChatsListWidget(
                        chats: chatsList,
                        token: token,
                      );
                    } else {
                      return const Center(
                        child: Text("Nothing to display"),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
