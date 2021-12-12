import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/widgets/widgets.dart';
import '../widgets/widgets.dart';
import '../../../common/data/user_dao.dart';

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

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _passConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          BasicFormField(
            controller: _firstNameController,
            hint: 'Имя',
            ifEmptyOrNull: 'Введите Имя',
          ),
          BasicFormField(
            controller: _lastNameController,
            hint: 'Фамилия',
            ifEmptyOrNull: 'Введите Фамилию',
          ),
          EmailFormField(emailController: _emailController),
          PasswordFormField(passwordController: _passController),
          PasswordConfirmFormField(
            passwordController: _passController,
            passwordConfirmController: _passConfirmController,
          ),
          SignUpButton(
            formKey: _formKey,
            userDao: userDao,
            emailController: _emailController,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            passController: _passController,
          ),
        ],
      ),
    );
  }
}
