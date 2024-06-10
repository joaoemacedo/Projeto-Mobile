import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservations.dart';

class ReservationProvider with ChangeNotifier {
  final List<Reservation> _reservations = [];

  List<Reservation> get reservations => _reservations;

  Future<void> fetchReservations() async {
    final snapshot = await FirebaseFirestore.instance.collection('reservations').get();
    _reservations.clear();
    for (var doc in snapshot.docs) {
      _reservations.add(Reservation.fromMap(doc.data(), doc.id));
    }
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    final docRef = await FirebaseFirestore.instance.collection('reservations').add(reservation.toMap());
    reservation.id = docRef.id;
    _reservations.add(reservation);
    notifyListeners();
  }

  Future<void> updateReservation(Reservation reservation) async {
    await FirebaseFirestore.instance.collection('reservations').doc(reservation.id).update(reservation.toMap());
    final index = _reservations.indexWhere((res) => res.id == reservation.id);
    if (index >= 0) {
      _reservations[index] = reservation;
      notifyListeners();
    }
  }

  Future<void> deleteReservation(String id) async {
    await FirebaseFirestore.instance.collection('reservations').doc(id).delete();
    _reservations.removeWhere((res) => res.id == id);
    notifyListeners();
  }
}
