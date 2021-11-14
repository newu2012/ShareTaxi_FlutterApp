import 'package:flutter/material.dart';

import 'home.dart';
import 'trip/trip.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  static final trips = <Trip>[
    Trip('С Меги на Ботанику', 1, 4, 240,
        DateTime.now().add(const Duration(minutes: 30))),
    Trip('С Ботанику в Мегу', 3, 4, 500,
        DateTime.now().add(const Duration(minutes: 35))),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO remove trips placeholder

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home(
        title: 'Flutter Demo Home Page',
        trips: trips,
      ),
    );
  }
}
