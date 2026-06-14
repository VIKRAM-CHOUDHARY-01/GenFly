import 'package:flutter/material.dart';
import '../../../../home/presentation/screens/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const _ComingSoonBody(
        icon: Icons.person_rounded,
        title: 'My Profile',
        subtitle: 'Manage your account, saved passengers\nand travel preferences.',
      ),
    );
  }
}
