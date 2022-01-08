import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/message.dart';
import '../../../common/data/fire_user_dao.dart';
import '../../../common/data/user.dart';
import '../../../common/data/user_dao.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);
    final fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    if (message.isSystem)
      return Center(
        child: FutureBuilder(
          future: UserDao().getUserByUid(message.args!.first),
          builder: (context, value) => value.hasData
              ? _buildSystemMessage(context, value.data as User)
              : const LinearProgressIndicator(),
        ),
      );

    return Padding(
      padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
      child: FutureBuilder(
        future: userDao.getUserByUid(message.userId),
        builder: (context, userSnapshot) {
          return userSnapshot.hasData
              ? _buildMessage(context, userSnapshot.data as User, fireUserDao)
              : const LinearProgressIndicator();
        },
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context, User user) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        TextButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/user',
            arguments: message.args!.first,
          ),
          child: Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(
              color: Color.fromARGB(255, 111, 108, 217),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Text(
          '${message.text}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMessage(context, User messageCreator, FireUserDao fireUserDao) {
    return fireUserDao.userId() == message.userId
        ? _buildCurrentUserMessage(context, messageCreator)
        : _buildAnotherUserMessage(context, messageCreator);
  }

  Widget _buildCurrentUserMessage(context, User messageCreator) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color.fromRGBO(154, 217, 237, 100),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMessageCreatorText(
                  '${messageCreator.firstName} ${messageCreator.lastName}',
                ),
                _buildMessageText(context),
                _buildMessageDate(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnotherUserMessage(BuildContext context, User messageCreator) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMessageCreatorAvatar(messageCreator.photoUrl),
          const SizedBox(
            width: 4,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color.fromRGBO(194, 193, 226, 100),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessageCreatorText(
                  '${messageCreator.firstName} ${messageCreator.lastName}',
                ),
                _buildMessageText(context),
                _buildMessageDate(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCreatorText(String userName) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        userName,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMessageText(context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width * 0.65,
      child: Text(
        message.text,
        softWrap: true,
      ),
    );
  }

  Widget _buildMessageDate() {
      return Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          DateFormat('kk:mm').format(message.date).toString(),
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black.withAlpha(124),
          ),
        ),
    );
  }

  Widget _buildMessageCreatorAvatar(String? userAvatarUrl) {
    return CircleAvatar(
      maxRadius: 16,
      backgroundImage: NetworkImage(userAvatarUrl ??
          'https://firebasestorage.googleapis.com/v0/b/newu-share-taxi.appspot.com/o/avatar.png?alt=media&token=735f2da2-a631-4650-9372-0ba9bfa673aa'),
    );
  }
}
