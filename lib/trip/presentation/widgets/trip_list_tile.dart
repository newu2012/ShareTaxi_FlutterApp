import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../common/data/fire_user_dao.dart';
import '../../../common/data/user.dart';
import '../../../common/data/user_dao.dart';
import '../../data/trip.dart';

class TripListTile extends StatelessWidget {
  const TripListTile(Trip this.trip, {Key? key}) : super(key: key);

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.title,
            style: const TextStyle(fontSize: 19),
          ),
          DistanceAndAddresses(userDao: userDao, trip: trip),
          Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(
                width: 4,
              ),
              Text('${DateFormat('HH:mm').format(trip.departureTime)} выезд'),
              const SizedBox(
                width: 12,
              ),
              const Icon(Icons.people),
              const SizedBox(
                width: 4,
              ),
              Text('${trip.currentCompanions}/${trip.maximumCompanions}'),
              const SizedBox(
                width: 12,
              ),
              const Icon(Icons.payments),
              const SizedBox(
                width: 4,
              ),
              Text('${trip.costOverall}/${trip.oneUserCost} руб.'),
            ],
          ),
        ],
      ),
    );
  }
}

double _calculateMeterDistance(LatLng p1, LatLng p2) {
  const distance = Distance();

  return distance(p1, p2);
}

class DistanceAndAddresses extends StatelessWidget {
  const DistanceAndAddresses({
    Key? key,
    required this.userDao,
    required this.trip,
  }) : super(key: key);

  final UserDao userDao;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userDao.getUserByUid(FireUserDao().userId()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data as User;

          return Column(
            children: [
              Row(
                children: [
                  DistanceFromPoint(user: user, point: trip.fromPoint),
                  Text(trip.fromPointAddress),
                ],
              ),
              Row(
                children: [
                  DistanceToPoint(user: user, point: trip.toPoint),
                  Text(trip.toPointAddress),
                ],
              ),
            ],
          );
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }
}

//  TODO Сделать общий класс вместо Distance...
class DistanceFromPoint extends StatelessWidget {
  final GeoPoint point;
  final User user;

  const DistanceFromPoint({Key? key, required this.user, required this.point})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meterDistance = _calculateMeterDistance(
      LatLng(user.fromPoint!.latitude, user.fromPoint!.longitude),
      LatLng(point.latitude, point.longitude),
    );

    return Row(
      children: [
        const Icon(MdiIcons.carArrowLeft),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 50,
          child: Text('${meterDistance}'),
        ),
      ],
    );
  }
}

class DistanceToPoint extends StatelessWidget {
  final GeoPoint point;
  final User user;

  const DistanceToPoint({Key? key, required this.user, required this.point})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meterDistance = _calculateMeterDistance(
      LatLng(user.toPoint!.latitude, user.toPoint!.longitude),
      LatLng(point.latitude, point.longitude),
    );

    return Row(
      children: [
        const Icon(MdiIcons.carArrowRight),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 50,
          child: Text('${meterDistance}'),
        ),
      ],
    );
  }
}
