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
  final _timeController = TextEditingController();
  final _costController = TextEditingController();

  var _maximumCompanions = 4;

  @override
  void dispose() {
    _titleController.dispose();
    _fromPointController.dispose();
    _toPointController.dispose();
    _timeController.dispose();
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
              maximumCompanions: _maximumCompanions,
              timeController: _timeController,
              tripDao: _tripDao,
              fireUserDao: _fireUserDao,
            ),
          ],
        ),
      ),
    );
  }
}
