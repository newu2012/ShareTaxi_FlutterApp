import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_taxi/trip/data/trip.dart';
import 'package:share_taxi/trip/data/trip_dao.dart';

import '../widgets/widgets.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  Widget build(BuildContext context) {
    final _tripDao = Provider.of<TripDao>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о поездке'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: _tripDao.getTripStreamById(tripId),
                  builder: (context, snapshot) => snapshot.hasData
                      ? GoogleMapWidget(
                          tripAddresses: [
                            (Trip.fromSnapshot(snapshot.data!))
                                .fromPointAddress,
                            (Trip.fromSnapshot(snapshot.data!)).toPointAddress,
                          ],
                        )
                      : const LinearProgressIndicator(),
                ),
                height: 170,
              ),
              TripInfoList(tripId: tripId),
            ],
          ),
        ),
      ),
    );
  }
}
