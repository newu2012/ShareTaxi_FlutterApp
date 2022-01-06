import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание поездки'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 111, 108, 217),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    child: GoogleMapWidget(),
                    height: 170,
                  ),
                  const CreateTripForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
