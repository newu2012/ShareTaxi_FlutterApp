import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../logic/map_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController mapController;
  var userDeniedGps = false;

  final TextEditingController fromPointController = TextEditingController();
  final TextEditingController toPointController = TextEditingController();
  late String fromPointAddress;
  late String toPointAddress;
  Marker? fromPointMarker;
  Marker? toPointMarker;

  @override
  void dispose() {
    fromPointController.dispose();
    toPointController.dispose();
    super.dispose();
  }

  Set<Marker> get _markers {
    final markers = <Marker>{};
    if (fromPointMarker != null) markers.add(fromPointMarker!);
    if (toPointMarker != null) markers.add(toPointMarker!);

    return markers;
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _moveCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
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
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withAlpha(200),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(0, 1),
                      color: Colors.black.withAlpha(35),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: fromPointController,
                      onSubmitted: (value) => searchAndNavigate,
                      onEditingComplete: () =>
                          searchAndNavigate(fromPointAddress, 'fromPoint'),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Откуда поедем',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 15.0, top: 15.0),
                        prefixIcon: SizedBox(
                          width: 64,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () =>
                              searchAndNavigate(fromPointAddress, 'fromPoint'),
                          iconSize: 30.0,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          fromPointAddress = val;
                        });
                      },
                    ),
                    const Divider(
                      height: 1,
                    ),
                    TextField(
                      controller: toPointController,
                      onSubmitted: (value) => searchAndNavigate,
                      onEditingComplete: () =>
                          searchAndNavigate(toPointAddress, 'toPoint'),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Куда поедем',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 15.0, top: 15.0),
                        prefixIcon: SizedBox(
                          width: 64,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () =>
                              searchAndNavigate(toPointAddress, 'toPoint'),
                          iconSize: 30.0,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          toPointAddress = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(0, 1),
                      color: Colors.black.withAlpha(35),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (fromPointMarker == null || toPointMarker == null)
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Введите оба адреса'),
                          ));
                        else
                          Navigator.pushNamed(context, '/trips');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('Поиск попутчиков'),
                        ],
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (fromPointMarker == null || toPointMarker == null)
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Введите оба адреса'),
                          ));
                        else
                          Navigator.pushNamed(context, '/createTrip');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('Создать поездку'),
                        ],
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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

  void searchAndNavigate(String address, String pointName) async {
    var coordinatesFromAddress;
    var finalAddress;
    try {
      final locationsFromAddress =
          await GeocodingPlatform.instance.locationFromAddress(
        address,
      );
      coordinatesFromAddress = LatLng(
        locationsFromAddress.first.latitude,
        locationsFromAddress.first.longitude,
      );
      final addressPlacemark =
          await GeocodingPlatform.instance.placemarkFromCoordinates(
        coordinatesFromAddress.latitude,
        coordinatesFromAddress.longitude,
        localeIdentifier: 'ru_RU',
      );
      finalAddress = getAddressFromPlacemark(addressPlacemark.first);
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось найти адрес')),
      );
    }

    setState(() {
      if (pointName == 'fromPoint') {
        fromPointMarker = _createMarker(coordinatesFromAddress, pointName);
        fromPointAddress = finalAddress;
        fromPointController.text = finalAddress;
        Provider.of<MapController>(context, listen: false).fromPointAddress =
            finalAddress;
        Provider.of<MapController>(context, listen: false).fromPointLatLng =
            coordinatesFromAddress;
      } else if (pointName == 'toPoint') {
        toPointMarker = _createMarker(coordinatesFromAddress, pointName);
        toPointAddress = finalAddress;
        toPointController.text = finalAddress;
        Provider.of<MapController>(context, listen: false).toPointAddress =
            finalAddress;
        Provider.of<MapController>(context, listen: false).toPointLatLng =
            coordinatesFromAddress;
      }
    });

    Provider.of<MapController>(context, listen: false).markers = _markers;
    _moveCamera();
  }

  String getAddressFromPlacemark(Placemark pl) {
    final finalAddress = '${pl.street}, ${pl.name}, ${pl.locality}';

    return finalAddress;
  }

  void _moveCamera() {
    try {
      if (_markers.isEmpty) return;

      final target = _markers.length == 2
          ? LatLng(
              (_markers.first.position.latitude +
                      _markers.last.position.latitude) /
                  2,
              (_markers.first.position.longitude +
                      _markers.last.position.longitude) /
                  2,
            )
          : _markers.first.position;

      var zoomLevel = 12.0;
      if (_markers.length == 2) {
        final radius = GeolocatorPlatform.instance.distanceBetween(
          _markers.first.position.latitude,
          _markers.first.position.longitude,
          _markers.last.position.latitude,
          _markers.last.position.longitude,
        );
        final scale = radius / 500;
        zoomLevel = (16 - log(scale * 1.5) / log(2));
      }

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: target,
        zoom: zoomLevel,
      )));
    } on Exception catch (e) {
      print(e);
    }
  }

  Marker _createMarker(LatLng position, String pointName) {
    return Marker(
      markerId: MarkerId(pointName),
      position: position,
      icon: BitmapDescriptor.defaultMarker,
    );
  }
}
