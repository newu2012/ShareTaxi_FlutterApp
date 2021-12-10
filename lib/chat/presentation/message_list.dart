import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_widget.dart';
import '../data/message.dart';
import '../data/message_dao.dart';
import '../../common/data/fire_user_dao.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key, required this.tripId}) : super(key: key);
  final String? tripId;

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? userId;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final messageDao = Provider.of<MessageDao>(context, listen: false);
    final fireUserDao = Provider.of<FireUserDao>(context, listen: false);
    userId = fireUserDao.userId();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getMessageList(messageDao),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      onSubmitted: (input) {
                        _sendMessage(messageDao);
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new message'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendMessage()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendMessage(messageDao);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(MessageDao messageDao) {
    if (_canSendMessage()) {
      final message = Message(
        tripId: widget.tripId,
        text: _messageController.text.trim(),
        date: DateTime.now(),
        // TODO Change chatId dynamically
        userId: userId,
      );
      messageDao.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }

  Widget _getMessageList(MessageDao messageDao) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: messageDao.getMessageStream(widget.tripId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          return _buildList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20.0),
        children: _messageList(context, snapshot));
  }

  List<Widget> _messageList(
      BuildContext context, List<DocumentSnapshot>? snapshot) {
    snapshot!.sort((a, b) =>
        Message.fromSnapshot(a).date.compareTo(Message.fromSnapshot(b).date));
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final message = Message.fromSnapshot(snapshot);
    return MessageWidget(message.text, message.date, message.userId);
  }

  bool _canSendMessage() => _messageController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
