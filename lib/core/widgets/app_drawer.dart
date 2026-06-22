import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../constants/app_routes.dart';
import 'animated_section.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _navItems = [
    _DrawerItem(Icons.home_rounded, 'Home', AppRoutes.home),
    _DrawerItem(Icons.book_rounded, 'My Bookings', AppRoutes.bookings),
    _DrawerItem(Icons.local_offer_rounded, 'Offers & Deals', AppRoutes.offers),
    _DrawerItem(Icons.headset_mic_rounded, 'Support', AppRoutes.support),
    _DrawerItem(Icons.person_rounded, 'My Profile', AppRoutes.profile),
  ];

  static const _moreItems = [
    _DrawerItem(Icons.info_outline_rounded, 'About GenFly', ''),
    _DrawerItem(Icons.star_rate_rounded, 'Rate the App', ''),
    _DrawerItem(Icons.share_rounded, 'Share App', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppTheme.brandGradient,
              ),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.secondary,
                  child: Text('V', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                ),
                const SizedBox(height: 10),
                const Text('Vikram Choudhary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: AppTheme.secondary),
                    const SizedBox(width: 4),
                    const Text('Gold Member', style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                ..._navItems.asMap().entries.map((e) => AnimatedSection(
                  delay: Duration(milliseconds: 60 + e.key * 55),
                  beginOffset: const Offset(-0.06, 0),
                  child: _DrawerTile(item: e.value, onTap: () {
                    Navigator.pop(context);
                    if (e.value.route.isNotEmpty) context.go(e.value.route);
                  }),
                )),
                const Divider(height: 24, indent: 16, endIndent: 16),
                ..._moreItems.asMap().entries.map((e) => AnimatedSection(
                  delay: Duration(milliseconds: 350 + e.key * 55),
                  beginOffset: const Offset(-0.06, 0),
                  child: _DrawerTile(item: e.value, onTap: () => Navigator.pop(context)),
                )),
                const Divider(height: 24, indent: 16, endIndent: 16),
                AnimatedSection(
                  delay: const Duration(milliseconds: 560),
                  beginOffset: const Offset(-0.06, 0),
                  child: _DrawerTile(
                    item: const _DrawerItem(Icons.logout_rounded, 'Logout', ''),
                    onTap: () => Navigator.pop(context),
                    isDestructive: true,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flight_takeoff_rounded, size: 16, color: AppTheme.primary),
                const SizedBox(width: 6),
                const Text('GenFly v1.0.0', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label, route;
  const _DrawerItem(this.icon, this.label, this.route);
}

class _DrawerTile extends StatelessWidget {
  final _DrawerItem item;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerTile({required this.item, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.error : AppTheme.textPrimary;
    final iconColor = isDestructive ? AppTheme.error : AppTheme.primary;

    return ListTile(
      leading: Icon(item.icon, color: iconColor, size: 22),
      title: Text(item.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      onTap: onTap,
      horizontalTitleGap: 8,
      dense: true,
    );
  }
}
