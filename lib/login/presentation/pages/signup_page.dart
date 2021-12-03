import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SignupForm()));
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var firstPassword = '';
  final TextEditingController _passController = TextEditingController();
  var _obfuscatePassword = true;
  final TextEditingController _passConfirmController = TextEditingController();
  var _obfuscateConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Имя*',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final name = value?.trim();
                if (name == null || name.isEmpty) return 'Введите Имя';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Фамилия*',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final surname = value?.trim();
                if (surname == null || surname.isEmpty)
                  return 'Введите Фамилию';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email*',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final email = value?.trim();
                if (email == null || email.isEmpty) return 'Введите email';
                if (!EmailValidator.validate(email))
                  return 'Введите действительный email';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passController,
              obscureText: _obfuscatePassword,
              decoration: InputDecoration(
                  hintText: 'Пароль*',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                            () => _obfuscatePassword = !_obfuscatePassword);
                      },
                      icon: Icon(
                        _obfuscatePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                      ))),
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
            const SizedBox(height: 8),
            TextFormField(
              controller: _passConfirmController,
              obscureText: _obfuscateConfirmPassword,
              decoration: InputDecoration(
                  hintText: 'Повторите пароль*',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obfuscateConfirmPassword =
                            !_obfuscateConfirmPassword);
                      },
                      icon: Icon(
                        _obfuscateConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                      ))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                final password = value?.trim();
                if (password == null || password.isEmpty)
                  return 'Введите подтверждение пароля';
                if (password != _passController.text)
                  return 'Пароли отличаются';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
