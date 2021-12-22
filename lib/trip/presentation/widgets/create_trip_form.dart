import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var _departureTime = DateTime.now();

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
      child: SizedBox(
        height: 600,
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Название поездки',
              ),
              controller: _titleController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 111, 108, 217),
                ),
                hintText: 'Адрес отправления',
              ),
              controller: _fromPointController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 255, 174, 3),
                ),
                hintText: 'Адрес назначения',
              ),
              controller: _toPointController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Количество человек'),
                SizedBox(
                  width: 85,
                  //padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: 4,
                    items:
                        <int>[2, 3, 4].map<DropdownMenuItem<int>>((int value) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Время отправления'),
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
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
            DigitsOnlyFormField(
              controller: _costController,
              hint: 'Сколько стоит',
              ifEmptyOrNull: 'Ожидаемая стоимость поездки для одного человека',
            ),
            CreateTripButton(
              formKey: _formKey,
              titleController: _titleController,
              costController: _costController,
              maximumCompanions: _maximumCompanions,
              departureTime: _departureTime,
              tripDao: _tripDao,
              fireUserDao: _fireUserDao,
            ),
          ],
        ),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${_departureTime.hour}:'
          '${_departureTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
