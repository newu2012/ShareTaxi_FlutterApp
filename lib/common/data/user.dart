import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  DocumentReference? reference;

  User(
      {required this.email,
      required this.firstName,
      required this.lastName,
      this.photoUrl,
      this.reference});

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photoUrl,
      };

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final user = User.fromJson(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference;
    return user;
  }
}
