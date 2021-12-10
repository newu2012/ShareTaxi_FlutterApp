import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../../../common/data/fire_user_dao.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: LoginForm()));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obfuscatePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<FireUserDao>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final email = value?.trim();
                if (email == null || email.isEmpty) return 'Введите email';
                if (!EmailValidator.validate(email))
                  return 'Введите действительный email';
                return null;
              },
            ),
            TextFormField(
              obscureText: _obfuscatePassword,
              decoration: InputDecoration(
                  hintText: 'Пароль',
                  suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => _obfuscatePassword = !_obfuscatePassword),
                      icon: Icon(
                        _obfuscatePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                      ))),
              controller: _passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final password = value?.trim();
                if (password == null || password.isEmpty)
                  return 'Введите пароль';
                if (password.length < 6)
                  return 'Введите пароль не менее 6 символов';
                return null;
              },
            ),
            //  TODO write function ForgotPassword
            TextButton(
                onPressed: () => null, child: const Text('Забыли пароль?')),
            ElevatedButton(
              onPressed: () {
                // TODO replace with server authentication
                if (_formKey.currentState!.validate()) {
                  userDao.login(_emailController.text.trim(),
                      _passwordController.text.trim());
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: const Text('Войти'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/signup'),
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
