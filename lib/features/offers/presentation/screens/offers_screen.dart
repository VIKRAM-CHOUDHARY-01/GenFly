import 'package:flutter/material.dart';
import '../../../../home/presentation/screens/home_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: const _ComingSoonBody(
        icon: Icons.local_offer_rounded,
        title: 'Offers & Deals',
        subtitle: 'Exclusive discounts, coupon codes\nand limited-time flight deals.',
      ),
    );
  }
}
