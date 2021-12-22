import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/data/fire_user_dao.dart';
import '../../data/trip_dao.dart';
import '../widgets/widgets.dart';
import '../../data/trip.dart';

class TripsListPage extends StatefulWidget {
  const TripsListPage({Key? key}) : super(key: key);

  @override
  State<TripsListPage> createState() => _TripsListPageState();
}

class _TripsListPageState extends State<TripsListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tripDao = Provider.of<TripDao>(context, listen: false);
    final userDao = Provider.of<FireUserDao>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getTripList(tripDao),
            _createTripButton(),
          ],
        ),
      ),
    );
  }

  Widget _createTripButton() {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/createTrip'),
      // onPressed: () => _buildTripModal(tripDao, userDao),
      child: const Text('Create trip'),
    );
  }

  Widget _getTripList(TripDao tripDao) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: tripDao.getTripStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: LinearProgressIndicator());

          return _buildList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: _tripList(context, snapshot),
    );
  }

  List<Widget> _tripList(
    BuildContext context,
    List<DocumentSnapshot>? snapshot,
  ) {
    snapshot!.sort((a, b) => Trip.fromSnapshot(a)
        .departureTime
        .compareTo(Trip.fromSnapshot(b).departureTime));

    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final trip = Trip.fromSnapshot(snapshot);

    return GestureDetector(
      child: TripListTile(trip),
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          Navigator.pushNamed(context, '/chat', arguments: trip.reference?.id),
    );
  }
}
