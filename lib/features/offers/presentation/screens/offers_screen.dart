import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _offers = [
    _OfferData('GENFLY10', '10% Off on First Booking', 'New users get 10% off on their first flight booking. Max discount ₹500.', 'Valid till 30 Jun 2026', AppTheme.primary, Icons.card_giftcard_rounded),
    _OfferData('SUMMER25', '₹250 Off on ₹3000+', 'Book flights above ₹3000 and get flat ₹250 off instantly.', 'Valid till 31 Jul 2026', Color(0xFF0097B2), Icons.wb_sunny_rounded),
    _OfferData('WEEKEND', 'Flat ₹500 Weekend Deal', 'Special weekend fares. Book Fri–Sun for extra savings.', 'Valid every weekend', Color(0xFFE68A00), Icons.weekend_rounded),
    _OfferData('HDFC15', '15% Off with HDFC Card', 'Pay using HDFC credit/debit card and save 15%. Max ₹750.', 'Valid till 31 Aug 2026', Color(0xFF5C6BC0), Icons.credit_card_rounded),
    _OfferData('EARLYBIRD', 'Early Bird — ₹400 Off', 'Book 30+ days in advance and save ₹400 on domestic flights.', 'No expiry', AppTheme.primary, Icons.alarm_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers & Deals')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _OfferCard(data: _offers[i]),
      ),
    );
  }
}

class _OfferData {
  final String code, title, desc, validity;
  final Color color;
  final IconData icon;
  const _OfferData(this.code, this.title, this.desc, this.validity, this.color, this.icon);
}

class _OfferCard extends StatelessWidget {
  final _OfferData data;
  const _OfferCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          // Color bar + icon header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(data.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.desc, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Coupon code chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.secondary, style: BorderStyle.solid),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 14, color: Color(0xFF8B6914)),
                          const SizedBox(width: 6),
                          Text(data.code, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF8B6914), letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Apply Now', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(data.validity, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
