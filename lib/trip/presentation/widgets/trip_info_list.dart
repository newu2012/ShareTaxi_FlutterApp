import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../chat/presentation/widgets/chat_list_tile.dart';
import 'distance_and_addresses_row.dart';
import '../../../common/data/fire_user_dao.dart';
import '../../data/trip.dart';
import '../../data/trip_dao.dart';

class TripInfoList extends StatefulWidget {
  const TripInfoList({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  _TripInfoListState createState() => _TripInfoListState();
}

class _TripInfoListState extends State<TripInfoList> {
  late Trip _trip;
  late TripDao _tripDao;
  late FireUserDao _fireUserDao;

  @override
  Widget build(BuildContext context) {
    _tripDao = Provider.of<TripDao>(context, listen: false);
    _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: _tripDao.getTripStreamById(widget.tripId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        _trip = Trip.fromSnapshot(snapshot.data!);

        return Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _trip.title,
                style: const TextStyle(fontSize: 19),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            AddressRow(
              trip: _trip,
              withDistance: _trip.creatorId != _fireUserDao.userId(),
            ),
            const SizedBox(
              height: 8,
            ),
            _buildMainInfoButton(),
          ],
        );
      },
    );
  }

  Widget _buildMainInfoButton() {
    if (_trip.creatorId == _fireUserDao.userId())
      return const SizedBox(
        height: 2,
      );
    if (!_trip.currentCompanions.contains(_fireUserDao.userId()))
      return JoinTripButton(
        trip: _trip,
        fireUserDao: _fireUserDao,
        tripDao: _tripDao,
        tripId: widget.tripId,
      );

    return LeaveTripButton(
      tripDao: _tripDao,
      trip: _trip,
      fireUserDao: _fireUserDao,
    );
  }
}

class JoinTripButton extends StatelessWidget {
  const JoinTripButton({
    Key? key,
    required this.trip,
    required this.fireUserDao,
    required this.tripDao,
    required this.tripId,
  }) : super(key: key);

  final Trip trip;
  final FireUserDao fireUserDao;
  final TripDao tripDao;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (trip.currentCompanions.length < trip.maximumCompanions) {
          var newCompanions = List<String>.from(trip.currentCompanions);
          newCompanions.add(fireUserDao.userId()!);
          newCompanions = newCompanions.toSet().toList();
          final newTrip = Trip.fromTrip(
            trip: trip,
            currentCompanions: newCompanions,
          );

          tripDao.updateTrip(id: trip.reference!.id, trip: newTrip);
          Navigator.pushReplacementNamed(
            context,
            '/chat',
            arguments: tripId,
          );
        } else {
          ScaffoldMessenger.of(context)
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'В поездке уже максимальное количество участников',
                ),
                backgroundColor: Colors.amber,
              ),
            );
        }
      },
      child: const Text(
        'Присоединиться к поездке',
      ),
    );
  }
}

class LeaveTripButton extends StatelessWidget {
  const LeaveTripButton({
    Key? key,
    required this.trip,
    required this.fireUserDao,
    required this.tripDao,
  }) : super(key: key);

  final Trip trip;
  final FireUserDao fireUserDao;
  final TripDao tripDao;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var newCompanions = List<String>.from(trip.currentCompanions);
        newCompanions.remove(fireUserDao.userId()!);
        newCompanions = newCompanions.toSet().toList();
        final newTrip = Trip.fromTrip(
          trip: trip,
          currentCompanions: newCompanions,
        );

        tripDao.updateTrip(id: trip.reference!.id, trip: newTrip);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: const Text(
        'Покинуть поездку',
      ),
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 216, 57, 76),
      ),
    );
  }
}

class AddressRow extends StatelessWidget {
  const AddressRow({Key? key, required this.trip, required this.withDistance})
      : super(key: key);
  final bool withDistance;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return withDistance
        ? DistanceAndAddressesRow(trip: trip)
        : Column(
            children: [
              AddressRowWithoutDistance(trip: trip, fromPoint: true),
              AddressRowWithoutDistance(trip: trip, fromPoint: false),
            ],
          );
  }
}
