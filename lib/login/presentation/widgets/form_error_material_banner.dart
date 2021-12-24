import 'package:flutter/material.dart';

class FormErrorMaterialBanner {
  static MaterialBanner getBanner(BuildContext context, String bannerText) {
    return MaterialBanner(
      leading: const Icon(Icons.info),
      content: Text(bannerText),
      backgroundColor: Colors.amber,
      actions: <Widget>[
        IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
