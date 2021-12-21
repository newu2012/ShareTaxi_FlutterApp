import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/data/fire_user_dao.dart';
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
      onPressed: () => _buildTripModal(tripDao, userDao),
      child: const Text('Create trip'),
    );
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
      children: _tripList(context, snapshot),
    );
  }

  List<Widget> _tripList(
    BuildContext context,
    List<DocumentSnapshot>? snapshot,
  ) {
    snapshot!.sort((a, b) => Trip.fromSnapshot(a)
        .departureTime
        .compareTo(Trip.fromSnapshot(b).departureTime));

    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final trip = Trip.fromSnapshot(snapshot);

    return GestureDetector(
      child: TripListTile(trip),
      behavior: HitTestBehavior.translucent,
      onTap: () =>
          Navigator.pushNamed(context, '/chat', arguments: trip.reference?.id),
    );
  }

  Future<void> _buildTripModal(TripDao tripDao, FireUserDao fireUserDao) {
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
              child: CreateTripListView(
                tripDao: tripDao,
                fireUserDao: fireUserDao,
                titleController: _titleController,
                timeController: _timeController,
                costController: _costController,
                formKey: _formKey,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreateTripListView extends StatelessWidget {
  const CreateTripListView({
    Key? key,
    required TripDao tripDao,
    required FireUserDao fireUserDao,
    required TextEditingController titleController,
    required TextEditingController timeController,
    required TextEditingController costController,
    required GlobalKey<FormState> formKey,
  })  : _tripDao = tripDao,
        _fireUserDao = fireUserDao,
        _titleController = titleController,
        _timeController = timeController,
        _costController = costController,
        _formKey = formKey,
        super(key: key);

  final TripDao _tripDao;
  final FireUserDao _fireUserDao;

  final TextEditingController _titleController;
  final TextEditingController _timeController;
  final TextEditingController _costController;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Название поездки',
          ),
          controller: _titleController,
        ),
        DigitsOnlyFormField(
          controller: _timeController,
          hint: 'Через сколько минут',
          ifEmptyOrNull: 'Количество минут от 0 до 1440',
        ),
        DigitsOnlyFormField(
          controller: _costController,
          hint: 'Сколько стоит',
          ifEmptyOrNull: 'Ожидаемая стоимость поездки для одного человека',
        ),
        CreateTripButton(
          formKey: _formKey,
          titleController: _titleController,
          costController: _costController,
          timeController: _timeController,
          tripDao: _tripDao,
          fireUserDao: _fireUserDao,
        ),
      ],
    );
  }
}
