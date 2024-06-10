import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String name;
  DateTime date;
  int partySize;

  Reservation({required this.id, required this.name, required this.date, required this.partySize});

  factory Reservation.fromMap(Map<String, dynamic> data, String documentId) {
    return Reservation(
      id: documentId,
      name: data['name'] as String,
      date: (data['date'] as Timestamp).toDate(),
      partySize: data['partySize'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'partySize': partySize,
    };
  }
}
