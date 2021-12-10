import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  GeoPoint? fromPoint;
  GeoPoint? toPoint;

  DocumentReference? reference;

  User(
      {required this.email,
      required this.firstName,
      required this.lastName,
      this.photoUrl,
      this.fromPoint,
      this.toPoint,
      this.reference});

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?,
      fromPoint: json['fromPoint'] as GeoPoint?,
      toPoint: json['toPoint'] as GeoPoint?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'fromPoint': fromPoint,
        'toPoint': toPoint,
      };

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final user = User.fromJson(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference;
    return user;
  }
}
