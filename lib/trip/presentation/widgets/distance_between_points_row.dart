import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widgets.dart';

class DistanceBetweenPointsRow extends StatelessWidget {
  final String fromPoint;
  final String toPoint;
  final bool fromUser;

  const DistanceBetweenPointsRow({
    Key? key,
    required this.fromPoint,
    required this.toPoint,
    required this.fromUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = fromUser
        ? Icon(
            MdiIcons.carArrowLeft,
            color: Theme.of(context).primaryColor,
          )
        : const Icon(
            MdiIcons.carArrowRight,
            color: Color.fromRGBO(255, 174, 3, 100),
          );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          width: 4,
        ),
        FutureBuilder(
          future: getDistance(fromPoint, toPoint),
          builder: (_, snapshot) {
            if (!snapshot.hasData) return const Text('...');
            final distance = snapshot.data as int;

            return distance > 1000
                ? Text('${(distance / 1000).toStringAsFixed(1)} км.')
                : Text('${distance} м.');
          },
        ),
      ],
    );
  }
}
