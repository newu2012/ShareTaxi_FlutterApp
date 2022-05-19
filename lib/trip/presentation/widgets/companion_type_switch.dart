import 'package:flutter/material.dart';

class CompanionTypeSwitch extends StatefulWidget {
  var companionTypeSwitch;
  var companionType;
  final Function updateSwitchState;

  CompanionTypeSwitch(
      {Key? key,
      required this.updateSwitchState,
      required this.companionTypeSwitch,
      required this.companionType})
      : super(key: key);

  @override
  State<CompanionTypeSwitch> createState() => _CompanionTypeSwitchState();
}

class _CompanionTypeSwitchState extends State<CompanionTypeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Пассажир',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Switch(
          value: widget.companionTypeSwitch,
          onChanged: (value) => widget.updateSwitchState(value),
        ),
        const Text(
          'Водитель',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
