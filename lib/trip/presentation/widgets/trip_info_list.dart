import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/trip.dart';
import '../../data/trip_dao.dart';

class TripInfoList extends StatefulWidget {
  const TripInfoList({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  _TripInfoListState createState() => _TripInfoListState();
}

class _TripInfoListState extends State<TripInfoList> {
  late Trip _trip;

  @override
  Widget build(BuildContext context) {
    final _tripDao = Provider.of<TripDao>(context, listen: false);

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: _tripDao.getTripStreamById(widget.tripId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        _trip = Trip.fromSnapshot(snapshot.data!);

        return Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(_trip.title),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                '/chat',
                arguments: widget.tripId,
              ),
              child: const Text(
                'Присоединиться к поездке',
              ),
            ),
          ],
        );
      },
    );
  }
}
