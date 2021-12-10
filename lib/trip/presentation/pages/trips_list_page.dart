import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../common/data/fire_user_dao.dart';
import '../../data/trip_dao.dart';
import '../widgets/trip_list_tile.dart';
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
    final userDao = Provider.of<FireUserDao>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getTripList(tripDao),
            _createTripButton(tripDao, userDao),
          ],
        ),
      ),
    );
  }

  Widget _createTripButton(TripDao tripDao, FireUserDao userDao) {
    return ElevatedButton(
        onPressed: () => _buildCreateTripModal(tripDao, userDao),
        child: const Text('Create trip'));
  }

  Widget _getTripList(TripDao tripDao) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: tripDao.getTripStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: LinearProgressIndicator());
          return _buildList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20.0),
        children: _tripList(context, snapshot));
  }

  List<Widget> _tripList(
      BuildContext context, List<DocumentSnapshot>? snapshot) {
    snapshot!.sort((a, b) => Trip.fromSnapshot(a)
        .departureTime
        .compareTo(Trip.fromSnapshot(b).departureTime));
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final trip = Trip.fromSnapshot(snapshot);
    return GestureDetector(
      child: TripListTile(trip),
      onTap: () => Navigator.pushNamed(
          context, '/chat',
          arguments: trip.reference?.id),
    );
  }

  Future<void> _buildCreateTripModal(TripDao tripDao, FireUserDao userDao) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _timeController = TextEditingController();
    final _costController = TextEditingController();

    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Название поездки',
                      ),
                      controller: _titleController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Через сколько минут',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _timeController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Сколько стоит',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _costController,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          tripDao.saveTrip(Trip(
                            creatorId: userDao.userId(),
                            title: _titleController.text,
                            costOverall: int.parse(_costController.text),
                            departureTime: DateTime.now().add(Duration(
                                minutes: int.parse(_timeController.text))),
                            currentCompanions: 1,
                            maximumCompanions: 4,
                          ));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Создать поездку'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
