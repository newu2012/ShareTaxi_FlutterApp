import 'package:flutter/material.dart';

import '../../../login/logic/validators.dart';

class BasicFormField extends StatelessWidget {
  const BasicFormField({
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
      decoration: InputDecoration(
        hintText: _hint,
      ),
      controller: _controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => Validators.basicValidator(value, _ifEmptyOrNull),
    );
  }
}
