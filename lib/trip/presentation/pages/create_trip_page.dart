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
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
