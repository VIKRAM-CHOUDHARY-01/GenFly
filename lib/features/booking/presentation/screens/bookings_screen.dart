import 'package:flutter/material.dart';
import '../../../../../core/widgets/coming_soon_body.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: const ComingSoonBody(
        icon: Icons.book_rounded,
        title: 'My Bookings',
        subtitle: 'View upcoming trips, past flights\nand manage your reservations.',
      ),
    );
  }
}
