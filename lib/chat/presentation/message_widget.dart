import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    return Padding(
        padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
        child: Column(
          children: [
            if (userId != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                    alignment: Alignment.topRight,
                    child: FutureBuilder(
                        future: userDao.getUserByUid(userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final user = (snapshot.data as User);
                            return Text(
                              '${user.firstName} ${user.lastName}',
                              style: const TextStyle(color: Colors.grey),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })),
              ),
            ],
            Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          blurRadius: 2.0,
                          offset: const Offset(0, 1.0))
                    ],
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white),
                child: MaterialButton(
                    disabledTextColor: Colors.black87,
                    padding: const EdgeInsets.only(left: 18),
                    onPressed: null,
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(message),
                          ],
                        ),
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
                    style: const TextStyle(color: Colors.grey),
                  )),
            ),
          ],
        ));
  }
}
