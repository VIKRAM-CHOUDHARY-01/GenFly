import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _menuItems = [
    _MenuItem(Icons.person_outline_rounded, 'Personal Details', 'Name, email, phone'),
    _MenuItem(Icons.people_outline_rounded, 'Saved Passengers', '2 passengers saved'),
    _MenuItem(Icons.credit_card_rounded, 'Payment Methods', 'Cards & wallets'),
    _MenuItem(Icons.wallet_rounded, 'GenFly Wallet', '₹250 available'),
    _MenuItem(Icons.notifications_outlined, 'Notifications', 'Manage alerts'),
    _MenuItem(Icons.language_rounded, 'Language & Currency', 'English · INR'),
    _MenuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQs and contact'),
    _MenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', ''),
    _MenuItem(Icons.logout_rounded, 'Logout', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildStats(),
          const SizedBox(height: 8),
          ..._menuItems.map((item) => _MenuTile(item: item)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('GenFly v1.0.0', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.primary,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.secondary,
            child: Text('V', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vikram Choudhary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(height: 2),
                Text('vikram@genfly.com', style: TextStyle(fontSize: 13, color: Colors.white70)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: AppTheme.secondary),
                    SizedBox(width: 4),
                    Text('Gold Member', style: TextStyle(fontSize: 12, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: AppTheme.divider),
      ),
      child: const Row(
        children: [
          Expanded(child: _StatItem('12', 'Trips')),
          _VerticalDivider(),
          Expanded(child: _StatItem('₹250', 'Wallet')),
          _VerticalDivider(),
          Expanded(child: _StatItem('3', 'Offers')),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: AppTheme.divider);
}

class _MenuItem {
  final IconData icon;
  final String title, subtitle;
  const _MenuItem(this.icon, this.title, this.subtitle);
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLogout = item.title == 'Logout';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? AppTheme.error.withValues(alpha: 0.1) : AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, size: 20, color: isLogout ? AppTheme.error : AppTheme.primary),
      ),
      title: Text(item.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isLogout ? AppTheme.error : AppTheme.textPrimary)),
      subtitle: item.subtitle.isNotEmpty ? Text(item.subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)) : null,
      trailing: isLogout ? null : const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
      onTap: () {},
    );
  }
}
