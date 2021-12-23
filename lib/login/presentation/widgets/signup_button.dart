import 'package:flutter/material.dart';

import '../../../common/data/user.dart';
import '../../../common/data/user_dao.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.userDao,
    required TextEditingController emailController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController passController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _passController = passController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final UserDao userDao;
  final TextEditingController _emailController;
  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _passController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final userId = userDao.createUser(
            User(
              email: _emailController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
            ),
            _passController.text.trim(),
          );
          userId.then((value) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
      },
      child: const Text('Зарегистрироваться'),
    );
  }
}
