import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../../data/data.dart';
import 'widgets.dart';
import '../../../chat/data/message.dart';
import '../../../chat/data/message_dao.dart';
import '../../../common/data/user.dart';
import '../../../common/data/user_dao.dart';
import '../../../chat/presentation/widgets/chat_list_tile.dart';
import '../../../common/data/fire_user_dao.dart';

class TripInfoList extends StatefulWidget {
  TripInfoList({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  var _companionTypeSwitch = false;
  var _companionType = CompanionType.passenger;

  @override
  _TripInfoListState createState() => _TripInfoListState();
}

class _TripInfoListState extends State<TripInfoList> {
  late Trip _trip;
  late TripDao _tripDao;
  late FireUserDao _fireUserDao;

  void refresh(bool value) {
    setState(() {
      if (_trip.currentCompanions
          .map((el) => el.userId)
          .contains(_fireUserDao.userId()!)) {
        final currentUser = _trip.currentCompanions
            .where((element) => element.userId == _fireUserDao.userId())
            .first;

        switch (value) {
          case true:
            currentUser.companionType = CompanionType.driver;
            break;
          case false:
            currentUser.companionType = CompanionType.passenger;
            break;
        }
      } else {
        switch (value) {
          case true:
            widget._companionType = CompanionType.driver;
            break;
          case false:
            widget._companionType = CompanionType.passenger;
            break;
        }
      }

      widget._companionTypeSwitch = value;
      _tripDao.updateTripCompanions(id: widget.tripId, trip: _trip);
    });
  }

  @override
  Widget build(BuildContext context) {
    _tripDao = Provider.of<TripDao>(context, listen: false);
    _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: _tripDao.getTripStreamById(widget.tripId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        _trip = Trip.fromSnapshot(snapshot.data!);

        if (_trip.currentCompanions
            .map((el) => el.userId)
            .contains(_fireUserDao.userId()!)) {
          final user = _trip.currentCompanions.firstWhere(
            (element) => element.userId == _fireUserDao.userId(),
          );

          widget._companionTypeSwitch =
              user.companionType == CompanionType.driver;
          widget._companionType = user.companionType;
        }

        return SizedBox(
          width: 300,
          child: Column(
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
              TripInfoRow(trip: _trip),
              const SizedBox(
                height: 8,
              ),
              CompanionsRow(
                trip: _trip,
              ),
              const SizedBox(
                height: 8,
              ),
              CompanionTypeSwitch(
                updateSwitchState: refresh,
                companionTypeSwitch: widget._companionTypeSwitch,
                companionType: widget._companionType,
              ),
              const SizedBox(
                height: 8,
              ),
              _buildMainInfoButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainInfoButton() {
    if (_trip.creatorId == _fireUserDao.userId())
      return const SizedBox(
        height: 2,
      );
    if (!_trip.currentCompanions
        .map((e) => e.userId)
        .contains(_fireUserDao.userId()))
      return JoinTripButton(
        trip: _trip,
        fireUserDao: _fireUserDao,
        tripDao: _tripDao,
        tripId: widget.tripId,
        companionType: widget._companionType,
      );

    return LeaveTripButton(
      tripDao: _tripDao,
      trip: _trip,
      fireUserDao: _fireUserDao,
      tripId: widget.tripId,
    );
  }
}

class TripInfoRow extends StatelessWidget {
  const TripInfoRow({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeCard(
          trip: trip,
        ),
        CompanionsCard(
          trip: trip,
        ),
        CostCard(
          trip: trip,
        ),
      ],
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                '${DateFormat('dd.MM\nHH:mm').format(trip.departureDateTime)}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanionsCard extends StatelessWidget {
  const CompanionsCard({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                '${trip.currentCompanions.length}/${trip.maximumCompanions}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CostCard extends StatelessWidget {
  const CostCard({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payments,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                '${trip.oneUserCost}/\n ${trip.costOverall}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanionsRow extends StatefulWidget {
  const CompanionsRow({Key? key, required this.trip}) : super(key: key);
  final Trip trip;

  @override
  _CompanionsRowState createState() => _CompanionsRowState();
}

class _CompanionsRowState extends State<CompanionsRow> {
  @override
  Widget build(BuildContext context) {
    final _userDao = Provider.of<UserDao>(context, listen: false);

    return Column(
      children: [
        const Text(
          'Попутчики',
          style: TextStyle(fontSize: 19.0),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.trip.currentCompanions.length,
            itemBuilder: (context, i) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: FutureBuilder<User>(
                  future: _userDao.getUserByUid(
                    widget.trip.currentCompanions
                        .map((e) => e.userId)
                        .toList()[i],
                  ),
                  builder: (context, snapshot) => snapshot.hasData
                      ? CompanionCard(
                          companion: snapshot.data!,
                          trip: widget.trip,
                        )
                      : const Center(child: LinearProgressIndicator()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CompanionCard extends StatelessWidget {
  const CompanionCard({Key? key, required this.companion, required this.trip})
      : super(key: key);
  final User companion;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final companionType = trip.currentCompanions
        .firstWhere((e) => e.userId == companion.reference!.id)
        .companionType;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pushNamed(
        context,
        '/user',
        arguments: companion.reference!.id,
      ),
      child: Badge(
        badgeContent: Icon(
          companionType == CompanionType.passenger
              ? Icons.person
              : Icons.directions_car,
          size: 16,
        ),
        animationType: BadgeAnimationType.scale,
        padding: const EdgeInsets.all(2),
        badgeColor: Colors.lightBlueAccent,
        position: const BadgePosition(top: 0, end: 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _buildMessageCreatorAvatar(companion.photoUrl),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    '${companion.firstName} ${companion.lastName}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCreatorAvatar(String? userAvatarUrl) {
    return CircleAvatar(
      maxRadius: 16,
      backgroundImage: NetworkImage(userAvatarUrl ??
          'https://firebasestorage.googleapis.com/v0/b/newu-share-taxi.appspot.com/o/avatar.png?alt=media&token=735f2da2-a631-4650-9372-0ba9bfa673aa'),
    );
  }
}

class LeaveTripButton extends StatelessWidget {
  const LeaveTripButton({
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
    final _messageDao = Provider.of<MessageDao>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        var newCompanions = List<Companion>.from(trip.currentCompanions);
        newCompanions.removeWhere((e) => e.userId == fireUserDao.userId()!);
        newCompanions = newCompanions.toSet().toList();
        final newTrip = Trip.fromTrip(
          trip: trip,
          currentCompanions: newCompanions,
        );

        tripDao.updateTripCompanions(id: trip.reference!.id, trip: newTrip);
        _messageDao.saveMessage(Message(
          text: 'вышел(ла) из поездки',
          date: DateTime.now(),
          tripId: tripId,
          isSystem: true,
          messageType: 'leaveTrip',
          args: [
            FireUserDao().userId()!,
          ],
        ));

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

class JoinTripButton extends StatelessWidget {
  JoinTripButton(
      {Key? key,
      required this.trip,
      required this.fireUserDao,
      required this.tripDao,
      required this.tripId,
      required this.companionType})
      : super(key: key);

  final Trip trip;
  final FireUserDao fireUserDao;
  final TripDao tripDao;
  final String tripId;
  final CompanionType companionType;

  late var _messageDao;

  @override
  Widget build(BuildContext context) {
    _messageDao = Provider.of<MessageDao>(context, listen: false);

    return ElevatedButton(
      onPressed: () => joinTrip(context),
      child: const Text(
        'Присоединиться к поездке',
      ),
    );
  }

  void joinTrip(BuildContext context) {
    {
      if (trip.currentCompanions.length < trip.maximumCompanions) {
        var newCompanions = List<Companion>.from(trip.currentCompanions);
        newCompanions.add(Companion(
          userId: fireUserDao.userId()!,
          companionType: companionType,
        ));
        newCompanions = newCompanions.toSet().toList();
        final newTrip = Trip.fromTrip(
          trip: trip,
          currentCompanions: newCompanions,
        );

        tripDao.updateTripCompanions(id: trip.reference!.id, trip: newTrip);
        _messageDao.saveMessage(Message(
          text: 'присоединился(ась) к поездке',
          date: DateTime.now(),
          tripId: tripId,
          isSystem: true,
          messageType: 'joinTrip',
          args: [
            FireUserDao().userId()!,
          ],
        ));

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
    }
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
        ? DistanceAndAddressesColumn(trip: trip)
        : Column(
            children: [
              AddressRowWithoutDistance(trip: trip, fromPoint: true),
              AddressRowWithoutDistance(trip: trip, fromPoint: false),
            ],
          );
  }
}
