import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'chat_page.dart';
import '../../../common/data/fire_user_dao.dart';
import '../../../trip/data/trip.dart';
import '../../../trip/data/trip_dao.dart';
import '../../../trip/presentation/widgets/trip_list_tile.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ScrollController _scrollController = ScrollController();
  late FireUserDao _fireUserDao;
  late TripDao _tripDao;

  @override
  Widget build(BuildContext context) {
    _fireUserDao = Provider.of<FireUserDao>(context, listen: false);
    _tripDao = Provider.of<TripDao>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            _getChatList(_tripDao),
          ],
        ),
      ),
    );
  }

  Widget _getChatList(TripDao tripDao) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: tripDao.getTripsByUserId(_fireUserDao.userId()!),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: LinearProgressIndicator());

            final trips =
                snapshot.data!.docs.map((e) => Trip.fromSnapshot(e)).toList();
            trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));

            return Column(
              children: _widgetsToBuild(trips),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _widgetsToBuild(List<Trip> trips) {
    final activeTrips = trips
        .where((trip) => trip.departureTime.isAfter(DateTime.now()))
        .toList();
    final inactiveTrips = trips
        .where((trip) => trip.departureTime.isBefore(DateTime.now()))
        .toList();

    final widgetsToBuild = <Widget>[];
    const textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
    );
    if (activeTrips.isNotEmpty)
      widgetsToBuild.addAll([
        const Text(
          'Текущие чаты',
          style: textStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        _buildList(activeTrips, true),
        const SizedBox(
          height: 16,
        ),
      ]);
    if (inactiveTrips.isNotEmpty)
      widgetsToBuild.addAll([
        const Text(
          'История чатов',
          style: textStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        _buildList(inactiveTrips, false),
      ]);

    return widgetsToBuild;
  }

  Widget _buildList(List<Trip> trips, bool active) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: trips.length,
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) => _buildListItem(context, trips[i], active),
    );
  }

  Widget _buildListItem(BuildContext context, Trip trip, bool active) {
    return GestureDetector(
      child: active ? TripListTile(trip) : ChatListTile(trip),
      behavior: HitTestBehavior.translucent,
      onTap: () => pushNewScreen(
        context,
        screen: ChatPage(tripId: trip.reference!.id),
      ),
    );
  }
}
