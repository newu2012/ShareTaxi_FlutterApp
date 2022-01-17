import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DistanceBetweenPointsRow extends StatelessWidget {
  final google.LatLng fromPoint;
  final google.LatLng toPoint;
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
        Builder(builder: (context) {
          final distance = const Distance()
              .distance(
                LatLng(fromPoint.latitude, fromPoint.longitude),
                LatLng(toPoint.latitude, toPoint.longitude),
              )
              .toInt();

          return distance > 1000
              ? Text('${(distance / 1000).toStringAsFixed(1)} км.')
              : Text('${distance} м.');
        }),
      ],
    );
  }
}
