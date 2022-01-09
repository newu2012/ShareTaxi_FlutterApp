import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';
import '../../../chat/presentation/pages/chat_page.dart';
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
            const Divider(
              height: 8,
              thickness: 2,
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            child: TextFormField(
              readOnly: true,
              initialValue: Provider.of<MapController>(context, listen: false)
                  .fromPointAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15.0),
                prefixIcon: SizedBox(
                  width: 64,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Text('От'),
                    ],
                  ),
                ),
                prefixIconColor: const Color.fromARGB(255, 111, 108, 217),
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: TextFormField(
              readOnly: true,
              initialValue: Provider.of<MapController>(context, listen: false)
                  .toPointAddress,
              decoration: InputDecoration(
                hintText: 'Куда поедем',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15.0),
                prefixIcon: SizedBox(
                  width: 64,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(255, 174, 3, 100),
                      ),
                      const Text('До'),
                    ],
                  ),
                ),
                prefixIconColor: const Color.fromARGB(255, 255, 174, 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
