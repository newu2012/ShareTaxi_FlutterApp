import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/widgets/widgets.dart';
import '../../data/data.dart';
import '../../logic/map_controller.dart';
import 'widgets.dart';

class UserAddressesPanel extends StatefulWidget {
  UserAddressesPanel({Key? key}) : super(key: key);
  var isTripPreferencesPanelExpanded = true;

  @override
  State<UserAddressesPanel> createState() => _UserAddressesPanelState();
}

class _UserAddressesPanelState extends State<UserAddressesPanel> {
  void changeExpandedState() {
    setState(() {
      widget.isTripPreferencesPanelExpanded =
          !widget.isTripPreferencesPanelExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
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

class TripPreferencesPanel extends StatefulWidget {
  late TripPreferences tripPreferences;
  final Function changeExpandedState;

  TripPreferencesPanel({
    Key? key,
    required Function this.changeExpandedState,
  }) : super(key: key);

  @override
  State<TripPreferencesPanel> createState() => _TripPreferencesPanelState();
}

class _TripPreferencesPanelState extends State<TripPreferencesPanel> {
  @override
  Widget build(BuildContext context) {
    widget.tripPreferences =
        Provider.of<TripPreferences>(context, listen: true);

    return SizedBox(
      height: 350,
      child: ListView(
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
            height: 8,
          ),
          TimePreferenceRow(),
          const SizedBox(
            height: 8,
          ),
          DistancePreferenceRow(),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Сортировка',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          //  TODO вернуть виджет
          SortingPreference(),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 80),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.changeExpandedState();
                    widget.tripPreferences.notifyPreferences();
                  });
                },
                child: const Text('Применить')),
          ),
        ],
      ),
    );
  }
}

class TimePreferenceRow extends StatefulWidget {
  TimePreferenceRow({
    Key? key,
  }) : super(key: key);

  @override
  State<TimePreferenceRow> createState() => _TimePreferenceRowState();
}

class _TimePreferenceRowState extends State<TimePreferenceRow> {
  late DateTime _departureDateTimePreference;
  late TripPreferences tripPreferences;

  void updateDepartureDateTimePreference(DateTime dateTime) {
    setState(() {
      _departureDateTimePreference = dateTime;
      tripPreferences.departureDateTimePreference =
          _departureDateTimePreference;
    });
  }

  @override
  Widget build(BuildContext context) {
    tripPreferences = Provider.of<TripPreferences>(context, listen: false);
    _departureDateTimePreference = tripPreferences.departureDateTimePreference;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Выезд до',
          style: TextStyle(fontSize: 16),
        ),
        DepartureDateTimeCard(
          departureDateTime: _departureDateTimePreference,
          updateDepartureDateTime: updateDepartureDateTimePreference,
        ),
      ],
    );
  }
}

class DistancePreferenceRow extends StatefulWidget {
  var distanceController = TextEditingController();

  DistancePreferenceRow({Key? key}) : super(key: key);

  @override
  State<DistancePreferenceRow> createState() => _DistancePreferenceRowState();
}

class _DistancePreferenceRowState extends State<DistancePreferenceRow> {
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

class SortingPreference extends StatefulWidget {
  const SortingPreference({Key? key}) : super(key: key);

  @override
  State<SortingPreference> createState() => _SortingPreferenceState();
}

class _SortingPreferenceState extends State<SortingPreference> {
  late TripPreferences tripPreferences;
  late SortPreference sortPreference = SortPreference.time;

  void updateRadioState(SortPreference? value) {
    setState(() {
      sortPreference = value!;
      tripPreferences.sortPreference = sortPreference;
    });
  }

  @override
  Widget build(BuildContext context) {
    tripPreferences = Provider.of<TripPreferences>(context, listen: false);
    sortPreference = tripPreferences.sortPreference;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Сортировать по',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: const Text('Время'),
                  value: SortPreference.time,
                  groupValue: sortPreference,
                  onChanged: (SortPreference? value) =>
                      updateRadioState(value)),
              RadioListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: const Text('Расстояние'),
                  value: SortPreference.distance,
                  groupValue: sortPreference,
                  onChanged: (SortPreference? value) =>
                      updateRadioState(value)),
              RadioListTile(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: const Text('Стоимость'),
                  value: SortPreference.cost,
                  groupValue: sortPreference,
                  onChanged: (SortPreference? value) =>
                      updateRadioState(value)),
            ],
          ),
        )
      ],
    );
  }
}
