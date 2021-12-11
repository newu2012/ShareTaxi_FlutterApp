import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/data/fire_user_dao.dart';
import '../../common/data/user.dart';
import '../../common/data/user_dao.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final DateTime date;
  final String? userId;

  const MessageWidget(this.message, this.date, this.userId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);
    final fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
      child: FutureBuilder(
        future: userDao.getUserByUid(userId),
        builder: (context, userSnapshot) {
          return userSnapshot.hasData
              ? _buildMessage(userSnapshot.data as User, fireUserDao)
              : const LinearProgressIndicator();
        },
      ),
    );
  }

  Widget _buildMessage(User messageCreator, FireUserDao fireUserDao) {
    return fireUserDao.userId() == userId
        ? _buildCurrentUserMessage(messageCreator)
        : _buildAnotherUserMessage(messageCreator);
  }

  Widget _buildCurrentUserMessage(User messageCreator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            _buildMessageCreatorText(
              '${messageCreator.firstName} ${messageCreator.lastName}',
            ),
            _buildMessageText(),
            _buildMessageDate(),
          ],
        ),
        _buildMessageCreatorAvatar(messageCreator.photoUrl),
      ],
    );
  }

  Widget _buildAnotherUserMessage(User messageCreator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildMessageCreatorAvatar(messageCreator.photoUrl),
        Column(
          children: [
            _buildMessageCreatorText(
              '${messageCreator.firstName} ${messageCreator.lastName}',
            ),
            _buildMessageText(),
            _buildMessageDate(),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageCreatorText(String userName) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          userName,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMessageText() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Text(message),
    );
  }

  Widget _buildMessageDate() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMessageCreatorAvatar(String? userAvatarUrl) {
    return CircleAvatar(
      maxRadius: 24,
      backgroundImage: NetworkImage(userAvatarUrl ??
          'https://firebasestorage.googleapis.com/v0/b/newu-share-taxi.appspot.com/o/avatar.png?alt=media&token=735f2da2-a631-4650-9372-0ba9bfa673aa'),
    );
  }
}
