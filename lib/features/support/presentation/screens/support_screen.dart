import 'package:flutter/material.dart';
import '../../../../home/presentation/screens/home_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: const _ComingSoonBody(
        icon: Icons.headset_mic_rounded,
        title: 'Support',
        subtitle: 'Get help with your bookings,\nrefunds and travel queries.',
      ),
    );
  }
}
