import 'package:email_validator/email_validator.dart';

class Validators {
  static String? basicValidator(String? value, String ifEmptyOrNull) {
    final name = value?.trim();
    if (name == null || name.isEmpty) return ifEmptyOrNull;

    return null;
  }

  static String? emailValidator(String? value) {
    final email = value?.trim();
    if (email == null || email.isEmpty) return 'Введите email';
    if (!EmailValidator.validate(email)) return 'Введите действительный email';

    return null;
  }

  static String? passwordValidator(String? value) {
    final password = value?.trim();
    if (password == null || password.isEmpty) return 'Введите пароль';
    if (password.length < 6) return 'Введите пароль не менее 6 символов';

    return null;
  }

  static String? confirmPasswordValidator(String? value, _passController) {
    final password = value?.trim();
    if (password == null || password.isEmpty)
      return 'Введите подтверждение пароля';
    if (password != _passController.text) return 'Пароли отличаются';

    return null;
  }
}