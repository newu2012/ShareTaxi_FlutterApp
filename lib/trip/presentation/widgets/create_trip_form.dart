import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/data.dart';
import '../../logic/map_controller.dart';
import '../../../common/presentation/widgets/widgets.dart';
import 'widgets.dart';
import '../../../common/data/fire_user_dao.dart';

class CreateTripForm extends StatefulWidget {
  const CreateTripForm({Key? key}) : super(key: key);

  @override
  _CreateTripFormState createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _fromPointController = TextEditingController();
  final _toPointController = TextEditingController();
  final _costController = TextEditingController();

  var _companionTypeSwitch = false;
  var _companionType = CompanionType.passenger;
  var _maximumCompanions = 4;
  var _departureDateTime =
      currentTimeWithoutSeconds().add(const Duration(minutes: 30));

  static DateTime currentTimeWithoutSeconds() {
    final now = DateTime.now();
    final nowFormatted =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    return nowFormatted;
  }

  void updateDepartureDateTime(DateTime dateTime) {
    setState(() {
      _departureDateTime = dateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _fromPointController.text =
        Provider.of<MapController>(context, listen: false).fromPointAddress ??
            '';
    _toPointController.text =
        Provider.of<MapController>(context, listen: false).toPointAddress ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fromPointController.dispose();
    _toPointController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void refresh(bool value) {
    setState(() {
      switch (value) {
        case true:
          _companionType = CompanionType.driver;
          break;
        case false:
          _companionType = CompanionType.passenger;
      }
      _companionTypeSwitch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tripDao = Provider.of<TripDao>(context, listen: false);
    final _fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Название поездки',
            ),
            controller: _titleController,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 111, 108, 217),
              ),
              hintText: 'Адрес отправления',
            ),
            controller: _fromPointController,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 255, 174, 3),
              ),
              hintText: 'Адрес назначения',
            ),
            controller: _toPointController,
          ),
          const SizedBox(
            height: 8,
          ),
          CompanionTypeSwitch(
            updateSwitchState: refresh,
            companionTypeSwitch: _companionTypeSwitch,
            companionType: _companionType,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Максимум человек',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                width: 85,
                //padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: 4,
                  items: <int>[2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Center(
                        child: Text(
                          value.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _maximumCompanions = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Время отправления',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              DepartureDateTimeCard(
                departureDateTime: _departureDateTime,
                updateDepartureDateTime:
                    updateDepartureDateTime,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Стоимость поездки',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                width: 85,
                child: DigitsOnlyFormField(
                  controller: _costController,
                  hint: 'Стоимость',
                  ifEmptyOrNull: 'Больше 0',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          CreateTripButton(
            formKey: _formKey,
            titleController: _titleController,
            fromPointAddress: _fromPointController.text,
            toPointAddress: _toPointController.text,
            costController: _costController,
            companionType: _companionType,
            maximumCompanions: _maximumCompanions,
            departureTime: _departureDateTime,
            tripDao: _tripDao,
            fireUserDao: _fireUserDao,
          ),
        ],
      ),
    );
  }
}
