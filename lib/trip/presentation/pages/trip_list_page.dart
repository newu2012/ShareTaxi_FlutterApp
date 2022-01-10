import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'pages.dart';
import '../../logic/map_controller.dart';
import '../../data/trip_dao.dart';
import '../widgets/widgets.dart';
import '../../data/trip.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({Key? key}) : super(key: key);

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tripDao = Provider.of<TripDao>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск поездок'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            const UserAddressesColumn(),
            _getTripList(tripDao),
          ],
        ),
      ),
    );
  }

  Widget _getTripList(TripDao tripDao) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: tripDao.getTripStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: LinearProgressIndicator());

            final trips =
                snapshot.data!.docs.map((e) => Trip.fromSnapshot(e)).toList();
            trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));

            return _buildList(trips);
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Trip> trips) {
    return ListView.builder(
      itemCount: trips.length,
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) => _buildListItem(context, trips[i]),
    );
  }

  Widget _buildListItem(BuildContext context, Trip trip) {
    return GestureDetector(
      child: TripListTile(trip),
      behavior: HitTestBehavior.translucent,
      onTap: () => pushNewScreen(
        context,
        screen: TripInfoPage(tripId: trip.reference!.id),
      ),
    );
  }
}
