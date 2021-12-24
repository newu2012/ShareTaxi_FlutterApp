import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireUserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future<String?> signup(String email, String password) async {
    try {
      final userCredentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();

      return userCredentials.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e);
      }
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredentials = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();

      return userCredentials.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e);
        rethrow;
      }
    }
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
