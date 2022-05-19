import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/data.dart';
import '../../../common/data/fire_user_dao.dart';

class CreateTripButton extends StatelessWidget {
  const CreateTripButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController titleController,
    required String fromPointAddress,
    required String toPointAddress,
    required TextEditingController costController,
    required CompanionType companionType,
    required int maximumCompanions,
    required DateTime departureTime,
    required TripDao tripDao,
    required FireUserDao fireUserDao,
  })  : _formKey = formKey,
        _titleController = titleController,
        _fromPointAddress = fromPointAddress,
        _toPointAddress = toPointAddress,
        _costController = costController,
        _companionType = companionType,
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
  final CompanionType _companionType;
  final int _maximumCompanions;
  final DateTime _departureTime;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Создать поездку'),
      onPressed: () async {
        Future<String> tripId;

        if (_formKey.currentState!.validate()) {
          final newTrip = Trip(
            creatorId: _fireUserDao.userId(),
            title: _titleController.text,
            fromPointAddress: _fromPointAddress,
            fromPointLatLng: (await GeocodingPlatform.instance
                    .locationFromAddress(_fromPointAddress))
                .map((e) => LatLng(e.latitude, e.longitude))
                .first,
            toPointAddress: _toPointAddress,
            toPointLatLng: (await GeocodingPlatform.instance
                    .locationFromAddress(_toPointAddress))
                .map((e) => LatLng(e.latitude, e.longitude))
                .first,
            costOverall: int.parse(_costController.text),
            departureTime: _departureTime,
            currentCompanions: [
              Companion(
                userId: _fireUserDao.userId()!,
                companionType: _companionType,
              ),
            ],
            maximumCompanions: _maximumCompanions,
          );
          tripId = _tripDao.saveTrip(newTrip);

          tripId.then(
            (value) => Navigator.pushReplacementNamed(
              context,
              '/chat',
              arguments: value,
            ),
          );
        }
      },
    );
  }
}
