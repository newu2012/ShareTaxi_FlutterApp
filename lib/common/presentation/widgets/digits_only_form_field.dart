import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../logic/validators.dart';

class DigitsOnlyFormField extends StatelessWidget {
  const DigitsOnlyFormField({
    Key? key,
    required TextEditingController controller,
    required String? hint,
    required String ifEmptyOrNull,
  })  : _controller = controller,
        _hint = hint,
        _ifEmptyOrNull = ifEmptyOrNull,
        super(key: key);

  final TextEditingController _controller;
  final String? _hint;
  final String _ifEmptyOrNull;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: _hint,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => Validators.basicValidator(value, _ifEmptyOrNull),
    );
  }
}
