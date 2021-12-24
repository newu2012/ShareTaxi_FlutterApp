import 'package:flutter/material.dart';

import 'widgets.dart';
import '../../../common/data/fire_user_dao.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.fireUserDao,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final FireUserDao fireUserDao;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final user = fireUserDao.login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
          user
              .then(
            (value) => {
              if (value != null) Navigator.pushReplacementNamed(context, '/'),
            },
          )
              .catchError(
            (e) {
              ScaffoldMessenger.of(context)
                ..removeCurrentMaterialBanner()
                ..showMaterialBanner(
                  FormErrorMaterialBanner.getBanner(context, e.toString()),
                );
            },
          );
        }
      },
      child: const Text('Войти'),
    );
  }
}
