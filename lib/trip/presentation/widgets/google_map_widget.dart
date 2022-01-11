import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key, this.tripAddresses}) : super(key: key);

  final List<String>? tripAddresses;

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;
  var userDeniedGps = false;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      setMarkers().then((value) => _markers = value);
      _moveCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _getCurrentLocation(),
        builder: (context, AsyncSnapshot<Position?> position) {
          return GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: position.hasData
                  ? LatLng(
                      position.data!.latitude,
                      position.data!.longitude,
                    )
                  : const LatLng(56.8439, 60.6529),
              zoom: 17.0,
            ),
            myLocationEnabled: position.hasData,
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer(),
              )),
          );
        },
      ),
    );
  }

  Future<Set<Marker>> setMarkers() async {
    final Set<Marker> tripMarkers = widget.tripAddresses != null
        ? await createMarkersFromAddresses(widget.tripAddresses!)
        : {};
    print(
      'Trip markers: ${tripMarkers.map((e) => '${e.markerId} ${e.position}')}',
    );
    final userMarkers =
        Provider.of<MapController>(context, listen: false).markers;
    print(
      'User markers: ${userMarkers.map((e) => '${e.markerId} ${e.position}')}',
    );
    final allMarkers = Set<Marker>.from(userMarkers)..addAll(tripMarkers);
    print(
      'All markers: ${allMarkers.map((e) => '${e.markerId} ${e.position}')}',
    );
    _markers = allMarkers;

    return _markers;
  }

  Future<Set<Marker>> createMarkersFromAddresses(List<String> addresses) async {
    final Set<Marker> markers = (await Future.wait(addresses.map((e) async {
      return _createMarker(
        (await GeocodingPlatform.instance.locationFromAddress(e))
            .map((e) => LatLng(e.latitude, e.longitude))
            .first,
        e,
      );
    })))
        .toSet();

    return markers;
  }

  Marker _createMarker(LatLng position, String pointName) {
    return Marker(
      markerId: MarkerId(pointName),
      position: position,
      icon: BitmapDescriptor.defaultMarker,
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    await setMarkers();

    if (userDeniedGps) return Future.error('User denied GPS');

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location permissions are denied');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        userDeniedGps = true;

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, '
          'we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition();
  }

  void _moveCamera() {
    try {
      if (_markers.isEmpty) return;

      final target = _markers.length > 1
          ? LatLng(
              (_markers
                      .map((e) => e.position.latitude)
                      .reduce((a, b) => a + b)) /
                  _markers.length,
              (_markers
                      .map((e) => e.position.longitude)
                      .reduce((a, b) => a + b)) /
                  _markers.length,
            )
          : _markers.first.position;

      var zoomLevel = 12.0;

      if (_markers.length > 1) {
        final radius = GeolocatorPlatform.instance.distanceBetween(
          _markers.first.position.latitude,
          _markers.first.position.longitude,
          _markers.last.position.latitude,
          _markers.last.position.longitude,
        );
        final scale = radius / 500;
        zoomLevel = (16 - log(scale * 1.5) / log(2)) - 1;
      }

      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: target,
        zoom: zoomLevel,
      )));
    } on Exception catch (e) {
      print(e);
    }
  }
}
