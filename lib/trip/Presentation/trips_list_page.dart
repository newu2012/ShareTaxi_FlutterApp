import 'package:flutter/material.dart';

import 'trip_list_tile.dart';
import '../trip.dart';

class TripsListPage extends StatelessWidget {
  const TripsListPage({Key? key, required this.trips}) : super(key: key);
  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.separated(
          itemCount: trips.length,
          itemBuilder: (BuildContext context, int index) {
            return TripListTile(trips[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        showUnselectedLabels: true,
        selectedItemColor: Colors.deepPurple,
        selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
        unselectedItemColor: Colors.deepPurple,
        unselectedIconTheme: const IconThemeData(color: Colors.deepPurple),
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Поиск'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.taxi_alert), label: '  Новая\nпоездка'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.question_answer), label: 'Чаты'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Профиль'),
        ],
      ),
    );
  }
}
