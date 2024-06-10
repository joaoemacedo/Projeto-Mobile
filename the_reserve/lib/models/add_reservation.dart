// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/reservation_provider.dart';
import '../models/reservations.dart';

class AddReservationScreen extends StatefulWidget {
  const AddReservationScreen({super.key});

  @override
  _AddReservationScreenState createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final _nameController = TextEditingController();
  final _partySizeController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      appBar: AppBar(title: const Text('Add Reservation')),
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
                final newReservation = Reservation(id: '', name: name, date: _selectedDate!, partySize: partySize);
                await reservationProvider.addReservation(newReservation);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Reservation added successfully!'),
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Add Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
