import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../trip/presentation/widgets/widgets.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      trip.title,
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${DateFormat('dd.MM.yy').format(trip.departureTime)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  MdiIcons.carArrowLeft,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      trip.fromPointAddress,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  MdiIcons.carArrowRight,
                  color: Color.fromRGBO(255, 174, 3, 100),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      trip.toPointAddress,
                    ),
                  ),
                ),
              ],
            ),
            TripMainInfoRow(trip: trip),
          ],
        ),
      ),
    );
  }
}
