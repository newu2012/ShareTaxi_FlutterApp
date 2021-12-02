import 'package:flutter/material.dart';

import '../widgets/trip_list_tile.dart';
import '../../trip.dart';

class TripsListPage extends StatelessWidget {
  const TripsListPage({Key? key, required this.trips}) : super(key: key);
  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: trips.length,
        itemBuilder: (BuildContext context, int index) {
          return TripListTile(trips[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
