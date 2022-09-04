import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pss/models/chat.dart';
import 'package:pss/models/user.dart';
import 'package:pss/service/pss_chat_api.dart';
import 'package:web_socket_channel/io.dart';

import '../service/pss_api.dart';
import '../widgets/appdrawer.dart';

class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = ScrollController();
  List<Message> messagesList = [];
  late String? next;
  late Map<String, dynamic> token;
  late Future<bool> _future;
  late IOWebSocketChannel channel;
  final _messageController = TextEditingController();

  Future<bool> fetchMessages() async {
    ApiResponse result = await getMessages(id: widget.user.id);
    if (result.hasData()) {
      final messagesResult = result.Data as MessagesListResult;
      setState(() {
        messagesList.addAll(messagesResult.results);
        next = messagesResult.next;
      });
      return true;
    }
    return false;
  }

  void getNext() async {
    ApiResponse result = await getNextMessages(next: next!);
    if (result.hasData()) {
      final messagesResult = result.Data as MessagesListResult;
      setState(() {
        messagesList.addAll(messagesResult.results);
        next = messagesResult.next;
      });
    }
  }

  void getToken() async {
    Map<String, dynamic> token_ = await SessionManager().get("token");
    setState(() {
      token = token_;
    });
  }

  void connectToSocket() async {
    IOWebSocketChannel channel_ =
        await connectWebSocket(userId: widget.user.id);
    setState(() {
      channel = channel_;
    });
    channel.stream.listen(
      (event) {
        final Map<String, dynamic> eventMap = jsonDecode(event);
        Message newMessage = Message.fromJson(eventMap);
        if (!mounted) return;
        setState(
          () {
            messagesList.insert(0, newMessage);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    getToken();
    connectToSocket();
    _future = fetchMessages();
    super.initState();
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
    var vw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        title: Text(
          "${widget.user.firstName} ${widget.user.lastName}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      endDrawer: const PssDrawer(),
      body: Container(
        color: const Color.fromARGB(255, 183, 165, 186),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                width: vw,
                child: FutureBuilder<bool>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        bool response = snapshot.hasData;
                        if (response) {
                          return ListView.builder(
                              controller: _controller,
                              reverse: true,
                              itemCount: messagesList.length,
                              itemBuilder: ((context, index) {
                                Message message = messagesList[index];
                                if (message.sender == token["id"]) {
                                  return Container(
                                    margin: EdgeInsets.only(left: vw * .02),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Text(
                                          message.text,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(right: vw * .02),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        message.text,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }));
                        }
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: vw,
              color: Colors.white,
              // height: 50.0,df
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 8,
                      // width: vw - 100.0,
                      child: TextField(
                        controller: _messageController,
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                            hintText: "Type your message here"),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        iconSize: 20.0,
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            channel.sink.add(_messageController.text.trim());
                            _messageController.clear();
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
