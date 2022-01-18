import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/message_widget.dart';
import '../../data/message.dart';
import '../../data/message_dao.dart';
import '../../../trip/data/trip_dao.dart';
import '../../../trip/data/trip.dart';
import '../../../common/data/fire_user_dao.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? userId;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final messageDao = Provider.of<MessageDao>(context, listen: false);
    final fireUserDao = Provider.of<FireUserDao>(context, listen: false);
    final tripDao = Provider.of<TripDao>(context, listen: false);
    userId = fireUserDao.userId();

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: tripDao.getTripStreamById(widget.tripId),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Text(Trip.fromSnapshot(snapshot.data!).title)
                : const Text('');
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 111, 108, 217),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/tripInfo',
              arguments: widget.tripId,
            ),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _getMessageList(messageDao),
            _buildSendMessageRow(messageDao),
          ],
        ),
      ),
    );
  }

  Row _buildSendMessageRow(MessageDao messageDao) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _messageController,
            onSubmitted: (input) {
              _sendMessage(messageDao);
            },
            decoration: const InputDecoration(hintText: 'Отправить сообщение'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: () {
            _sendMessage(messageDao);
          },
        ),
      ],
    );
  }

  void _sendMessage(MessageDao messageDao) {
    if (_canSendMessage()) {
      final message = Message(
        tripId: widget.tripId,
        text: _messageController.text.trim(),
        date: DateTime.now(),
        userId: userId,
        messageType: 'text',
      );

      setState(() {
        messageDao.saveMessage(message);
        _messageController.clear();
      });
    }
  }

  Widget _getMessageList(MessageDao messageDao) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: messageDao.getMessageStream(widget.tripId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          return _messageList(snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _messageList(List<DocumentSnapshot>? snapshot) {
    snapshot!.sort((a, b) =>
        Message.fromSnapshot(a).date.compareTo(Message.fromSnapshot(b).date));
    snapshot.map((data) => _buildListItem(data)).toList();

    return ListView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      children: snapshot.map((data) => _buildListItem(data)).toList(),
    );
  }

  Widget _buildListItem(DocumentSnapshot snapshot) {
    final message = Message.fromSnapshot(snapshot);

    return MessageWidget(message);
  }

  bool _canSendMessage() => _messageController.text.length > 0;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
