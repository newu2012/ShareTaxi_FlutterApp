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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Создание поездки',
              style: TextStyle(
                fontSize: 36,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(
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
