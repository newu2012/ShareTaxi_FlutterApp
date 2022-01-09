import 'package:flutter/material.dart';

import '../widgets/google_map_widget.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о поездке'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(
                child: GoogleMapWidget(),
                height: 170,
              ),

              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    '/chat',
                    arguments: tripId,
                  ),
                child: const Text(
                  'Присоединиться к поездке',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
