// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_reserve/models/add_reservation.dart';
import 'package:the_reserve/models/edit_reservations.dart';
import '../provider/reservation_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Reservas')),
      ),
      body: FutureBuilder(
        future: reservationProvider.fetchReservations(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: reservationProvider.reservations.length,
            itemBuilder: (ctx, index) {
              final reservation = reservationProvider.reservations[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(reservation.name),
                  subtitle: Text('Date: ${reservation.date.toLocal()} | Party Size: ${reservation.partySize}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Theme.of(context).hintColor),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EditReservationScreen(reservation: reservation),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Theme.of(context).hintColor),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text('Are you sure you want to delete this reservation?'),
                              actions: [
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          );
                          if (confirm) {
                            await reservationProvider.deleteReservation(reservation.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Reservation deleted successfully!'),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).hintColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddReservationScreen()));
        },
      ),
    );
  }
}