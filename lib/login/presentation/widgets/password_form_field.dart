import 'package:flutter/material.dart';

import '../../logic/validators.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    Key? key,
    required TextEditingController passwordController,
  })  : _passwordController = passwordController,
        super(key: key);

  final TextEditingController _passwordController;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obfuscatePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: _obfuscatePassword,
      decoration: InputDecoration(
        hintText: 'Пароль',
        suffixIcon: IconButton(
          onPressed: () => setState(
            () => _obfuscatePassword = !_obfuscatePassword,
          ),
          icon: Icon(
            _obfuscatePassword ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.passwordValidator,
    );
  }
}
