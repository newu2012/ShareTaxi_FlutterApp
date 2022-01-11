import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
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
    final mapController = Provider.of<MapController>(context, listen: false);

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
            _getTripList(tripDao, mapController),
          ],
        ),
      ),
    );
  }

  Widget _getTripList(TripDao tripDao, MapController mapController) {
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

            return FutureBuilder(
              future: _sortTripsByDistance(trips, mapController),
              builder: (context, snapshot) => snapshot.hasData
                  ? _buildList(snapshot.data! as List<Trip>)
                  : const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<List<Trip>> _sortTripsByDistance(
    List<Trip> trips,
    MapController mapController,
  ) async {
    final tripsWithDistance = await Future.wait(trips.map((e) async {
      return [
        e,
        await getDistance(
          mapController.toPointAddress,
          e.toPointAddress,
        ),
        await getDistance(
          mapController.fromPointAddress,
          e.fromPointAddress,
        ),
      ];
    }));

    tripsWithDistance.sort((a, b) {
      return ((a[1] as int) + (a[2] as int)) - ((b[1] as int) + (b[2] as int));
    });
    final tripsSorted =
        List<Trip>.from(tripsWithDistance.map((e) => e.first).toList());

    return tripsSorted;
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

  Future<int> getDistance(String fromAddress, String toAddress) async {
    final fromLocation =
        (await GeocodingPlatform.instance.locationFromAddress(fromAddress))
            .map((e) => LatLng(e.latitude, e.longitude))
            .first;
    final toLocation =
        (await GeocodingPlatform.instance.locationFromAddress(toAddress))
            .map((e) => LatLng(e.latitude, e.longitude))
            .first;

    final distance =
        const Distance().distance(fromLocation, toLocation).toInt();

    return distance;
  }
}
