import 'package:flutter/material.dart';

import '../../logic/validators.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    Key? key,
    required TextEditingController emailController,
  }) : _emailController = emailController, super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.emailValidator,
    );
  }
}