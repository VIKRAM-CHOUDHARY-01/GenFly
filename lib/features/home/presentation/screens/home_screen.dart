import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_drawer.dart';
import '../../../../../core/widgets/animated_section.dart';
import '../../../../../core/constants/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _from = 'Delhi';
  String _to = 'Mumbai';
  String _date = '25 Jun 2026';
  String _travellers = '1 Adult, Economy';
  bool _isRoundTrip = false;
  late AnimationController _swapController;
  late Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _swapRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _swapController.dispose();
    super.dispose();
  }

  void _swapCities() {
    _swapController.forward(from: 0);
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: AnimatedSection(
              delay: const Duration(milliseconds: 80),
              child: _buildSearchCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSection(
              delay: const Duration(milliseconds: 220),
              child: _buildOffersSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSection(
              delay: const Duration(milliseconds: 360),
              child: _buildPopularRoutes(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          const Icon(Icons.flight_takeoff_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          const Text(
            'GenFly',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.secondary,
            child: Text('V', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF007A3D), Color(0xFF00A651), Color(0xFF00C261)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 64, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Book Flights\nWithout Hidden\nCharges',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Save up to ₹1000 on every booking.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Transform.translate(
        offset: const Offset(0, -24),
        child: Card(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // One-way / Round trip toggle
                Row(
                  children: [
                    _TripTypeChip(
                      label: 'One Way',
                      selected: !_isRoundTrip,
                      onTap: () => setState(() => _isRoundTrip = false),
                    ),
                    const SizedBox(width: 8),
                    _TripTypeChip(
                      label: 'Round Trip',
                      selected: _isRoundTrip,
                      onTap: () => setState(() => _isRoundTrip = true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // From / To fields with swap
                Row(
                  children: [
                    Expanded(
                      child: _SearchField(
                        label: 'FROM',
                        value: _from,
                        icon: Icons.flight_takeoff_rounded,
                        onTap: () {},
                      ),
                    ),
                    GestureDetector(
                      onTap: _swapCities,
                      child: RotationTransition(
                        turns: _swapRotation,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.swap_horiz_rounded, color: AppTheme.primary, size: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _SearchField(
                        label: 'TO',
                        value: _to,
                        icon: Icons.flight_land_rounded,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date and Travellers
                Row(
                  children: [
                    Expanded(
                      child: _SearchField(
                        label: 'DEPARTURE',
                        value: _date,
                        icon: Icons.calendar_today_rounded,
                        onTap: () {},
                      ),
                    ),
                    if (_isRoundTrip) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SearchField(
                          label: 'RETURN',
                          value: 'Select',
                          icon: Icons.calendar_today_outlined,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                _SearchField(
                  label: 'TRAVELLERS & CLASS',
                  value: _travellers,
                  icon: Icons.people_outline_rounded,
                  onTap: () {},
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),

                // Search button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Search Flights'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    final offers = [
      _OfferData('GENFLY10', '10% Off', 'Use on your first booking', AppTheme.secondary),
      _OfferData('SUMMER25', '₹250 Off', 'On flights above ₹3000', AppTheme.skyBlue),
      _OfferData('WEEKEND', 'Flat ₹500', 'Weekend getaway special', const Color(0xFFFFB347)),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exclusive Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: offers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _OfferCard(data: offers[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRoutes() {
    final routes = [
      _RouteData('DEL', 'BOM', 'Delhi → Mumbai', '₹3,499', 'Non-stop · 2h 15m'),
      _RouteData('BOM', 'BLR', 'Mumbai → Bengaluru', '₹2,899', 'Non-stop · 1h 45m'),
      _RouteData('DEL', 'GOI', 'Delhi → Goa', '₹4,199', '1 Stop · 3h 30m'),
      _RouteData('HYD', 'DEL', 'Hyderabad → Delhi', '₹3,799', 'Non-stop · 2h 5m'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ...routes.map((r) => _RouteCard(data: r)),
        ],
      ),
    );
  }
}

// --- Sub-widgets ---

class _TripTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TripTypeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SearchField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _OfferData {
  final String code, title, desc;
  final Color color;
  const _OfferData(this.code, this.title, this.desc, this.color);
}

class _OfferCard extends StatelessWidget {
  final _OfferData data;
  const _OfferCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(data.code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              Text(data.desc, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteData {
  final String from, to, label, price, info;
  const _RouteData(this.from, this.to, this.label, this.price, this.info);
}

class _RouteCard extends StatelessWidget {
  final _RouteData data;
  const _RouteCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(data.from, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              const Icon(Icons.flight_rounded, size: 14, color: AppTheme.textSecondary),
              Text(data.to, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(data.info, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(data.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              const Text('onwards', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
