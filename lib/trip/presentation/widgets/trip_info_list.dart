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

  @override
  Widget build(BuildContext context) {
    final _tripDao = Provider.of<TripDao>(context, listen: false);
    final _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

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
            ElevatedButton(
              onPressed: () {
                if (_trip.currentCompanions.length < _trip.maximumCompanions) {
                  var newCompanions =
                      List<String>.from(_trip.currentCompanions);
                  newCompanions.add(_fireUserDao.userId()!);
                  newCompanions = newCompanions.toSet().toList();
                  final newTrip = Trip.fromTrip(
                    trip: _trip,
                    currentCompanions: newCompanions,
                  );

                  _tripDao.updateTrip(id: _trip.reference!.id, trip: newTrip);
                  Navigator.pushReplacementNamed(
                    context,
                    '/chat',
                    arguments: widget.tripId,
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
            ),
          ],
        );
      },
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
