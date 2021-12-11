import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Произошло что-то страшное. Лучше вызывайте скорую.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
