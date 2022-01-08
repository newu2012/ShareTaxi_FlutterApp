import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../../../common/data/fire_user_dao.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: SafeArea(
          child: LoginForm(),
        ),
      ),
    );
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fireUserDao = Provider.of<FireUserDao>(context, listen: false);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          const Center(
            child: Text(
              'Share Taxi',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //  TODO save image to app
          Image.network(
            'https://psv4.userapi.com/c505536/u87264347/docs/d24/b939ecef92b3/Illustation.png?extra=PN_ThodO3TaZuauvuzwarhvGnkuM5AwQObH7a153d3kIILtdOv-mhsdBXXyH2EbkPzyc9ts3dXLDcYVtm9U7OjVUD-OS_1D6qds6KJM5pRWo37eYGsTObqCtFK380ZuqC3iUyLPBSvtfMHM5CiAi',
          ),
          const Center(
            child: Text(
              'Вместе дешевле',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          EmailFormField(emailController: _emailController),
          const SizedBox(
            height: 8,
          ),
          PasswordFormField(
            passwordController: _passwordController,
          ),
          //  TODO write function ForgotPassword
          Container(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => null,
              child: const Text('Забыли пароль?'),
            ),
          ),
          LogInButton(
            formKey: _formKey,
            fireUserDao: fireUserDao,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: const Text('Зарегистрироваться'),
          ),
        ],
      ),
    );
  }
}
