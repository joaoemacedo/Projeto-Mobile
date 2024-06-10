// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/reservation_provider.dart';
import '../models/reservations.dart';

class EditReservationScreen extends StatefulWidget {
  final Reservation reservation;

  const EditReservationScreen({super.key, required this.reservation});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  final _nameController = TextEditingController();
  final _partySizeController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.reservation.name;
    _partySizeController.text = widget.reservation.partySize.toString();
    _selectedDate = widget.reservation.date;
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choose Date'),
                ),
              ],
            ),
            TextField(
              controller: _partySizeController,
              decoration: const InputDecoration(labelText: 'Party Size'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please choose a date.'),
                  ));
                  return;
                }
                final partySize = int.parse(_partySizeController.text);
                final updatedReservation = Reservation(
                  id: widget.reservation.id,
                  name: name,
                  date: _selectedDate!,
                  partySize: partySize,
                );
                await reservationProvider.updateReservation(updatedReservation);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Reservation updated successfully!'),
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Update Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
