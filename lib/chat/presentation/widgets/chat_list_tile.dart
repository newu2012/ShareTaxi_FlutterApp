import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../trip/data/trip.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile(this.trip, {Key? key}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.title,
              style: const TextStyle(fontSize: 19),
            ),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text('${DateFormat('HH:mm').format(trip.departureTime)} выезд'),
                const SizedBox(
                  width: 12,
                ),
                Icon(
                  Icons.people,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '${trip.currentCompanions.length}/${trip.maximumCompanions}',
                ),
                const SizedBox(
                  width: 12,
                ),
                Icon(
                  Icons.payments,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text('${trip.costOverall}/${trip.oneUserCost} руб.'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
