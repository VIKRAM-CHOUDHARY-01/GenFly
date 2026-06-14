import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/animated_section.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _notifications = [
    _NotifData(Icons.flight_takeoff_rounded, 'Booking Confirmed', 'Your flight DEL → BOM on 28 Jun is confirmed. PNR: GF-20261842', '2 hours ago', true, AppTheme.primary),
    _NotifData(Icons.local_offer_rounded, 'New Offer Just for You!', 'Use GENFLY10 and save 10% on your next booking. Valid till 30 Jun.', '5 hours ago', true, Color(0xFFE68A00)),
    _NotifData(Icons.account_balance_wallet_rounded, 'Wallet Credited', '₹250 has been added to your GenFly Wallet from refund.', 'Yesterday', true, AppTheme.primary),
    _NotifData(Icons.flight_land_rounded, 'Flight Reminder', 'Your flight BOM → GOI departs in 24 hours. Check-in is now open.', 'Yesterday', false, Color(0xFF0097B2)),
    _NotifData(Icons.cancel_rounded, 'Booking Cancelled', 'Your booking GF-20260201 (MAA → DEL) has been cancelled. Refund in 5–7 days.', '15 Jun', false, AppTheme.error),
    _NotifData(Icons.star_rounded, 'Gold Member Unlocked!', 'Congratulations! You have unlocked Gold membership. Enjoy priority support.', '10 Jun', false, Color(0xFFE68A00)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (_, i) => AnimatedSection(
          delay: Duration(milliseconds: 60 + i * 70),
          beginOffset: const Offset(0, 0.05),
          child: _NotifTile(data: _notifications[i]),
        ),
      ),
    );
  }
}

class _NotifData {
  final IconData icon;
  final String title, body, time;
  final bool isUnread;
  final Color color;
  const _NotifData(this.icon, this.title, this.body, this.time, this.isUnread, this.color);
}

class _NotifTile extends StatelessWidget {
  final _NotifData data;
  const _NotifTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.isUnread ? AppTheme.primary.withValues(alpha: 0.04) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, color: data.color, size: 22),
            ),
            if (data.isUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          data.title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: data.isUnread ? FontWeight.w700 : FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(data.body, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
            const SizedBox(height: 4),
            Text(data.time, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
