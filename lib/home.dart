import 'package:flutter/material.dart';

import 'trip/trip.dart';
import 'trip/Presentation/trips_list_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.title, required this.trips})
      : super(key: key);
  final String title;
  // TODO remove trips placeholder
  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          key: const ValueKey('Trips'),
          child: TripsListPage(trips: trips),
        )
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}
