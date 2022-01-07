import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';
import '../../../chat/presentation/pages/chat_page.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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

            return _buildList(context, snapshot.data!.docs);
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    snapshot!.sort((a, b) => Trip.fromSnapshot(a)
        .departureTime
        .compareTo(Trip.fromSnapshot(b).departureTime));
    final tripsFromSnapshot =
        snapshot.map((data) => _buildListItem(context, data)).toList();

    return ListView.separated(
      itemCount: tripsFromSnapshot.length,
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      itemBuilder: (context1, i) => tripsFromSnapshot[i],
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final trip = Trip.fromSnapshot(snapshot);

    return GestureDetector(
      child: TripListTile(trip),
      behavior: HitTestBehavior.translucent,
      onTap: () => pushNewScreen(
        context,
        screen: ChatPage(tripId: trip.reference!.id),
      ),
    );
  }
}

class UserAddressesColumn extends StatelessWidget {
  const UserAddressesColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).primaryColor.withAlpha(180),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(MdiIcons.carArrowLeft),
              const SizedBox(
                width: 4,
              ),
              SizedBox(
                child: Text(
                  Provider.of<MapController>(context, listen: false)
                      .fromPointAddress,
                  style: const TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(MdiIcons.carArrowLeft),
              const SizedBox(
                width: 4,
              ),
              SizedBox(
                child: Text(
                  Provider.of<MapController>(context, listen: false)
                      .toPointAddress,
                  style: const TextStyle(fontSize: 19),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
