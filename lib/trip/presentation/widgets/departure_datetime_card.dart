import 'package:flutter/material.dart';

class DepartureDateTimeCard extends StatelessWidget {
  DepartureDateTimeCard({
    Key? key,
    required DateTime this.departureDateTime,
    required Function this.updateDepartureDateTime,
  }) : super(key: key);

  DateTime departureDateTime;
  final Function updateDepartureDateTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 14)),
        );
        final pickedTime = await showTimePicker(
          context: context,
          initialEntryMode: TimePickerEntryMode.input,
          initialTime: TimeOfDay(
            hour: departureDateTime.hour,
            minute: departureDateTime.minute,
          ),
        );
        if (pickedDate != null && pickedTime != null) {
          departureDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          updateDepartureDateTime(departureDateTime);
        }
      },
      child: SizedBox(
        width: 130,
        child: Card(
          color: const Color.fromRGBO(111, 108, 217, 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${departureDateTime.day.toString().padLeft(2, '0')}.'
                  '${departureDateTime.month.toString().padLeft(2, '0')} '
                  '${departureDateTime.hour}:'
                  '${departureDateTime.minute.toString().padLeft(2, '0')}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
