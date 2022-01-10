import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';
import '../../../common/presentation/widgets/widgets.dart';
import 'widgets.dart';
import '../../data/trip_dao.dart';
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

  var _maximumCompanions = 4;
  var _departureTime = DateTime.now().add(
    const Duration(minutes: 30),
  );

  @override
  void initState() {
    super.initState();
    _fromPointController.text =
        Provider.of<MapController>(context, listen: false).fromPointAddress;
    _toPointController.text =
        Provider.of<MapController>(context, listen: false).toPointAddress;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fromPointController.dispose();
    _toPointController.dispose();
    _costController.dispose();
    super.dispose();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Количество человек',
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
              GestureDetector(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: TimeOfDay(
                      hour: _departureTime.hour,
                      minute: _departureTime.minute,
                    ),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      final time = DateTime.now();
                      _departureTime = DateTime(
                        time.year,
                        time.month,
                        time.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: DepartureTimeCard(departureTime: _departureTime),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DigitsOnlyFormField(
            controller: _costController,
            hint: 'Сколько стоит',
            ifEmptyOrNull: 'Ожидаемая стоимость поездки для одного человека',
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
            maximumCompanions: _maximumCompanions,
            departureTime: _departureTime,
            tripDao: _tripDao,
            fireUserDao: _fireUserDao,
          ),
        ],
      ),
    );
  }
}

class DepartureTimeCard extends StatelessWidget {
  const DepartureTimeCard({
    Key? key,
    required DateTime departureTime,
  })  : _departureTime = departureTime,
        super(key: key);

  final DateTime _departureTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(111, 108, 217, 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Text(
          '${_departureTime.hour}:'
          '${_departureTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
