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
    required TextEditingController costController,
    required TextEditingController timeController,
    required TripDao tripDao,
    required FireUserDao fireUserDao,
  })  : _formKey = formKey,
        _titleController = titleController,
        _costController = costController,
        _timeController = timeController,
        _tripDao = tripDao,
        _fireUserDao = fireUserDao,
        super(key: key);

  final TripDao _tripDao;
  final FireUserDao _fireUserDao;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _titleController;
  final TextEditingController _costController;
  final TextEditingController _timeController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _tripDao.saveTrip(Trip(
            creatorId: _fireUserDao.userId(),
            title: _titleController.text,
            fromPoint: const GeoPoint(56.84, 60.65),
            toPoint: const GeoPoint(56.85, 60.6),
            costOverall: int.parse(_costController.text),
            departureTime: DateTime.now().add(Duration(
              minutes: int.parse(_timeController.text),
            )),
            currentCompanions: 1,
            maximumCompanions: 4,
          ));
          Navigator.pop(context);
        }
      },
      child: const Text('Создать поездку'),
    );
  }
}
