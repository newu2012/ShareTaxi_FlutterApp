import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/trip.dart';
import '../../../common/data/fire_user_dao.dart';
import '../../data/trip_dao.dart';

class CreateTripButton extends StatelessWidget {
  const CreateTripButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController titleController,
    required String fromPointAddress,
    required String toPointAddress,
    required TextEditingController costController,
    required int maximumCompanions,
    required DateTime departureTime,
    required TripDao tripDao,
    required FireUserDao fireUserDao,
  })  : _formKey = formKey,
        _titleController = titleController,
        _fromPointAddress = fromPointAddress,
        _toPointAddress = toPointAddress,
        _costController = costController,
        _maximumCompanions = maximumCompanions,
        _departureTime = departureTime,
        _tripDao = tripDao,
        _fireUserDao = fireUserDao,
        super(key: key);

  final TripDao _tripDao;
  final FireUserDao _fireUserDao;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _titleController;
  final String _fromPointAddress;
  final String _toPointAddress;
  final TextEditingController _costController;
  final int _maximumCompanions;
  final DateTime _departureTime;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Future<String> tripId;

        if (_formKey.currentState!.validate()) {
          tripId = _tripDao.saveTrip(Trip(
            creatorId: _fireUserDao.userId(),
            title: _titleController.text,
            fromPointAddress: _fromPointAddress,
            toPointAddress: _toPointAddress,
            fromPoint: const GeoPoint(56.84, 60.65),
            toPoint: const GeoPoint(56.85, 60.6),
            costOverall: int.parse(_costController.text),
            departureTime: _departureTime,
            currentCompanions: 1,
            maximumCompanions: _maximumCompanions,
          ));

          tripId.then((value) => Navigator.pushReplacementNamed(
                context,
                '/chat',
                arguments: value,
              ));
        }
      },
      child: const Text('Создать поездку'),
    );
  }
}
