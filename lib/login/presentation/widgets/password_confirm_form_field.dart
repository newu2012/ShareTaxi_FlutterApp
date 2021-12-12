import 'package:flutter/material.dart';

import '../../../common/logic/validators.dart';

class PasswordConfirmFormField extends StatefulWidget {
  const PasswordConfirmFormField({
    Key? key,
    required TextEditingController passwordController,
    required TextEditingController passwordConfirmController,
  })  : _passwordController = passwordController,
        _passwordConfirmController = passwordConfirmController,
        super(key: key);

  final TextEditingController _passwordController;
  final TextEditingController _passwordConfirmController;

  @override
  State<PasswordConfirmFormField> createState() =>
      _PasswordConfirmFormFieldState();
}

class _PasswordConfirmFormFieldState extends State<PasswordConfirmFormField> {
  bool _obfuscatePasswordConfirm = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordConfirmController,
      obscureText: _obfuscatePasswordConfirm,
      decoration: InputDecoration(
        hintText: 'Повторите пароль',
        suffixIcon: IconButton(
          onPressed: () {
            setState(
              () => _obfuscatePasswordConfirm = !_obfuscatePasswordConfirm,
            );
          },
          icon: Icon(
            _obfuscatePasswordConfirm ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => Validators.confirmPasswordValidator(
        value,
        widget._passwordController,
      ),
    );
  }
}
