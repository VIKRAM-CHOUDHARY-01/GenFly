import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../home/presentation/screens/home_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: const _ComingSoonBody(
        icon: Icons.book_rounded,
        title: 'My Bookings',
        subtitle: 'View upcoming trips, past flights\nand manage your reservations.',
      ),
    );
  }
}
