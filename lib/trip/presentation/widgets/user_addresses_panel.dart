import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/widgets/widgets.dart';
import '../../data/data.dart';
import '../../logic/map_controller.dart';

class UserAddressesPanel extends StatefulWidget {
  UserAddressesPanel({Key? key}) : super(key: key);
  var isTripPreferencesPanelExpanded = true;

  @override
  State<UserAddressesPanel> createState() => _UserAddressesPanelState();
}

class _UserAddressesPanelState extends State<UserAddressesPanel> {
  late TripPreferences tripPreferences;

  void changeExpandedState() {
    setState(() {
      widget.isTripPreferencesPanelExpanded =
          !widget.isTripPreferencesPanelExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    tripPreferences = Provider.of<TripPreferences>(context, listen: true);

    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: [
        ExpansionPanel(
          isExpanded: widget.isTripPreferencesPanelExpanded,
          headerBuilder: (BuildContext buildContext, bool isExpanded) =>
              Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                  child: TextFormField(
                    readOnly: true,
                    initialValue:
                        Provider.of<MapController>(context, listen: false)
                            .fromPointAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 15.0),
                      prefixIcon: SizedBox(
                        width: 64,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                            const Text('От'),
                          ],
                        ),
                      ),
                      prefixIconColor: const Color.fromARGB(255, 111, 108, 217),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: TextFormField(
                    readOnly: true,
                    initialValue:
                        Provider.of<MapController>(context, listen: false)
                            .toPointAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 15.0),
                      prefixIcon: SizedBox(
                        width: 64,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color.fromRGBO(255, 174, 3, 100),
                            ),
                            const Text('До'),
                          ],
                        ),
                      ),
                      prefixIconColor: const Color.fromARGB(255, 255, 174, 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TripPreferencesPanel(
            tripPreferences: tripPreferences,
            changeExpandedState: changeExpandedState,
          ),
        ),
      ],
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          widget.isTripPreferencesPanelExpanded =
              !widget.isTripPreferencesPanelExpanded;
        });
      },
    );
  }
}

class TripPreferencesPanel extends StatelessWidget {
  final TripPreferences tripPreferences;
  final Function changeExpandedState;
  final TripPreferences newTripPreferences = TripPreferences();

  TripPreferencesPanel({
    Key? key,
    required TripPreferences this.tripPreferences,
    required Function this.changeExpandedState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      shrinkWrap: true,
      children: [
        const Divider(thickness: 4),
        const Text(
          'Фильтры',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        TimePreferenceRow(),
        const SizedBox(
          height: 8,
        ),
        DistancePreference(),
        const SizedBox(
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
              onPressed: () {
                changeExpandedState();
              },
              child: const Text('Применить')),
        ),
      ],
    );
  }
}

class TimePreferenceRow extends StatefulWidget {
  TimePreferenceRow({
    Key? key,
  }) : super(key: key);
  var timeController = TextEditingController();

  @override
  State<TimePreferenceRow> createState() => _TimePreferenceRowState();
}

class _TimePreferenceRowState extends State<TimePreferenceRow> {
  @override
  Widget build(BuildContext context) {
    final tripPreferences =
        Provider.of<TripPreferences>(context, listen: false);

    widget.timeController.text =
        tripPreferences.departureDateTimePreference.toString();

    widget.timeController.addListener(() {
      if (widget.timeController.text.length != 0) {
        tripPreferences.departureDateTimePreference =
            DateTime.parse(widget.timeController.text);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Выезд до',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 85,
          // child:  showDateRangePicker(context: context, firstDate: firstDate,
          // lastDate: lastDate)
          child: GestureDetector(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialEntryMode: TimePickerEntryMode.input,
                initialTime: TimeOfDay(
                  hour: tripPreferences.departureDateTimePreference.hour,
                  minute: tripPreferences.departureDateTimePreference.minute,
                ),
              );
              if (pickedTime != null) {
                setState(() {
                  final time = DateTime.now();
                  tripPreferences.departureDateTimePreference = DateTime(
                    time.year,
                    time.month,
                    time.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });
              }
            },
            child: Text(tripPreferences.departureDateTimePreference.toString()),
          ),
        ),
      ],
    );
  }
}

class DistancePreference extends StatefulWidget {
  var distanceController = TextEditingController();

  DistancePreference({Key? key}) : super(key: key);

  @override
  State<DistancePreference> createState() => _DistancePreferenceState();
}

class _DistancePreferenceState extends State<DistancePreference> {
  @override
  Widget build(BuildContext context) {
    final tripPreferences =
        Provider.of<TripPreferences>(context, listen: false);

    widget.distanceController.text =
        tripPreferences.distanceMetersPreference.toString();
    widget.distanceController.addListener(() {
      if (widget.distanceController.text.length != 0) {
        tripPreferences.distanceMetersPreference =
            int.parse(widget.distanceController.text);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Расстояние до',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 85,
          child: DigitsOnlyFormField(
            controller: widget.distanceController,
            hint: 'Метров',
            ifEmptyOrNull: 'Больше 0',
          ),
        ),
      ],
    );
  }
}
