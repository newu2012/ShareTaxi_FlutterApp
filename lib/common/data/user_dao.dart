import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'fire_user_dao.dart';
import 'user.dart';

class UserDao extends ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');

  Future<String> createUser(User user, String password) async {
    try {
      final userId = await FireUserDao().signup(user.email, password);
      saveUser(user, userId!);

      return userId;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void saveUser(User user, String userId) async {
    try {
      collection.doc(userId).get().then((value) async {
        if (value.exists) {
          print('User already exists');

          return;
        } else {
          return (collection.doc(userId).set(user.toJson()));
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserStream() {
    return collection.snapshots();
  }

  Future<User> getUserByUid(String? uid) async {
    return User.fromSnapshot(await collection.doc(uid).get());
  }
}
