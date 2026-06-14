import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _faqs = [
    _FaqData('How do I cancel my booking?', 'Go to My Bookings → select booking → tap Cancel. Refunds are processed within 5–7 business days.'),
    _FaqData('Can I change my travel date?', 'Yes, date changes are allowed up to 4 hours before departure. Rescheduling fee may apply.'),
    _FaqData('How do I get my e-ticket?', 'Your e-ticket is sent to your registered email after booking. You can also download it from My Bookings.'),
    _FaqData('What is the baggage allowance?', 'Economy: 15kg check-in + 7kg cabin. Business: 25kg check-in + 10kg cabin. Varies by airline.'),
    _FaqData('How do I apply a coupon code?', 'Enter your coupon code on the payment screen before completing the booking.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact options
          const Text('Contact Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ContactCard(icon: Icons.call_rounded, label: 'Call Us', sub: '1800-XXX-XXXX', color: AppTheme.primary, onTap: () {})),
              const SizedBox(width: 12),
              Expanded(child: _ContactCard(icon: Icons.chat_rounded, label: 'Live Chat', sub: 'Avg. wait 2 min', color: AppTheme.skyBlue, onTap: () {})),
              const SizedBox(width: 12),
              Expanded(child: _ContactCard(icon: Icons.email_rounded, label: 'Email', sub: 'support@genfly', color: AppTheme.secondary, onTap: () {})),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ..._faqs.map((f) => _FaqTile(data: f)),
          const SizedBox(height: 20),
          // Help card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFF007A3D)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Need more help?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      SizedBox(height: 2),
                      Text('Our team is available 24/7 for you.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                    foregroundColor: AppTheme.textPrimary,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  child: const Text('Chat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  const _ContactCard({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FaqData {
  final String q, a;
  const _FaqData(this.q, this.a);
}

class _FaqTile extends StatelessWidget {
  final _FaqData data;
  const _FaqTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        iconColor: AppTheme.primary,
        collapsedIconColor: AppTheme.textSecondary,
        title: Text(data.q, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        children: [
          Text(data.a, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
