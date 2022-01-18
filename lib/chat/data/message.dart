import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? tripId;
  final String text;
  final DateTime date;
  final String? userId;
  final bool isSystem;
  final String messageType;

  final List<dynamic>? args;

  DocumentReference? reference;

  Message({
    required this.text,
    required this.date,
    required this.tripId,
    this.userId,
    this.isSystem = false,
    required this.messageType,
    this.args,
    this.reference,
  });

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
        tripId: json['tripId'] as String?,
        text: json['text'] as String,
        date: DateTime.parse(json['date'] as String),
        userId: json['userId'] as String?,
        isSystem: json['isSystem'] as bool,
        messageType: json['messageType'] as String,
        args: json['args'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tripId': tripId,
        'date': date.toString(),
        'text': text,
        'userId': userId,
        'isSystem': isSystem,
        'messageType': messageType,
        'args': args,
      };

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    final message = Message.fromJson(snapshot.data() as Map<String, dynamic>);
    message.reference = snapshot.reference;
    message.tripId ?? message.reference?.id;

    return message;
  }
}
