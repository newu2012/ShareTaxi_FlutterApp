import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? tripId;
  final String text;
  final DateTime date;
  final String? email;

  DocumentReference? reference;

  Message(
      {required this.text,
      required this.date,
      this.tripId,
      this.email,
      this.reference});

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
      tripId: json['tripId'] as String?,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      email: json['email'] as String?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tripId': tripId,
        'date': date.toString(),
        'text': text,
        'email': email,
      };

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    final message = Message.fromJson(snapshot.data() as Map<String, dynamic>);
    message.reference = snapshot.reference;
    message.tripId ?? message.reference?.id;
    return message;
  }
}
