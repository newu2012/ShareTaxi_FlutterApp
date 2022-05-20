import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/widgets/widgets.dart';
import '../../logic/map_controller.dart';

class UserAddressesPanel extends StatefulWidget {
  UserAddressesPanel({Key? key}) : super(key: key);
  var _expanded = false;

  @override
  State<UserAddressesPanel> createState() => _UserAddressesPanelState();
}

class _UserAddressesPanelState extends State<UserAddressesPanel> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: [
        ExpansionPanel(
          isExpanded: widget._expanded,
          canTapOnHeader: true,
          headerBuilder: (BuildContext buildContext, bool isExpanded) =>
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          body: const TripPreferencesPanel(),
        ),
      ],
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          widget._expanded = !widget._expanded;
        });
      },
    );
  }
}

class TripPreferencesPanel extends StatelessWidget {
  const TripPreferencesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        const Text(
          'Фильтры',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        TimePreferenceRow(),
      ],
    );
  }
}

class TimePreferenceRow extends StatefulWidget {
  TimePreferenceRow({Key? key}) : super(key: key);
  var timeController = TextEditingController();

  @override
  State<TimePreferenceRow> createState() => _TimePreferenceRowState();
}

class _TimePreferenceRowState extends State<TimePreferenceRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Выезд в пределах скольки часов?'),
        SizedBox(
          width: 85,
          child: DigitsOnlyFormField(
              controller: widget.timeController,
              hint: 'Часы',
              ifEmptyOrNull: 'Полные часы'),
        ),
      ],
    );
  }
}
