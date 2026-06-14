import 'package:flutter/material.dart';
import '../../../../../core/widgets/coming_soon_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GenFly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: const ComingSoonBody(
        icon: Icons.flight_takeoff_rounded,
        title: 'Home',
        subtitle: 'Search flights, explore deals\nand manage your trips.',
      ),
    );
  }
}
