import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String _fromCode = 'DEL';
  String _to = 'Mumbai';
  String _toCode = 'BOM';
  String _date = '25 Jun 2026';
  String _travellers = '1 Adult, Economy';
  bool _isRoundTrip = false;

  late AnimationController _swapController;
  late Animation<double> _swapRotation;

  final PageController _sliderController = PageController();
  int _currentSlide = 0;
  Timer? _sliderTimer;

  static const _slides = [
    _SlideData(
      icon: Icons.flight_takeoff_rounded,
      title: 'Book Flights Instantly',
      subtitle: 'Compare fares across all airlines\nand fly smarter every time.',
      gradient: [Color(0xFF0D3B2E), Color(0xFF00C853)],
    ),
    _SlideData(
      icon: Icons.track_changes_rounded,
      title: 'Real-Time Flight Tracking',
      subtitle: 'Know exactly where your\nflight is — live on your screen.',
      gradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    _SlideData(
      icon: Icons.card_giftcard_rounded,
      title: 'Earn Rewards Every Trip',
      subtitle: 'Collect points on every booking\nand redeem for free flights.',
      gradient: [Color(0xFF4A148C), Color(0xFFAB47BC)],
    ),
    _SlideData(
      icon: Icons.support_agent_rounded,
      title: '24/7 Support Always Ready',
      subtitle: 'Chat, call or email.\nWe\'re here whenever you need us.',
      gradient: [Color(0xFF004D40), Color(0xFF26A69A)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _swapRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOutBack),
    );
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentSlide + 1) % _slides.length;
      _sliderController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _swapController.dispose();
    _sliderController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  void _swapCities() {
    _swapController.forward(from: 0);
    setState(() {
      final tempCity = _from;
      _from = _to;
      _to = tempCity;
      final tempCode = _fromCode;
      _fromCode = _toCode;
      _toCode = tempCode;
    });
  }

  Future<void> _openWhatsApp() async {
    // Replace with your actual WhatsApp support number (country code + number, no +)
    const phone = '919876543210';
    const message = 'Hi GenFly! I need help with my booking.';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback: open wa.me in browser
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      floatingActionButton: _WhatsAppFab(onTap: _openWhatsApp),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildSlider()),
          // Clear visual gap — no negative translate pulling the card into the slider
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: AnimatedSection(
              delay: const Duration(milliseconds: 100),
              child: _buildSearchCard(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      // App logo: clipped to a rounded square so background square disappears
      title: Image.asset(
        'assets/images/New_logo.png',
        height: 38,
        fit: BoxFit.contain,
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.secondary,
            child: const Text('V', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PageView.builder(
            controller: _sliderController,
            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) => _SlideCard(data: _slides[i]),
          ),
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentSlide == i ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentSlide == i ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Padding(
      // No negative offset — sits cleanly below the slider gap
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Gradient header with trip type toggle
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.brandGradient),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  _TripChip(
                    label: 'One Way',
                    selected: !_isRoundTrip,
                    onTap: () => setState(() => _isRoundTrip = false),
                  ),
                  const SizedBox(width: 10),
                  _TripChip(
                    label: 'Round Trip',
                    selected: _isRoundTrip,
                    onTap: () => setState(() => _isRoundTrip = true),
                  ),
                  const Spacer(),
                  const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCityRow(),
                  const SizedBox(height: 16),
                  _FlightPathDivider(isRoundTrip: _isRoundTrip),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.calendar_today_rounded,
                          label: 'DEPARTURE',
                          value: _date,
                        ),
                      ),
                      if (_isRoundTrip) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.event_available_rounded,
                            label: 'RETURN',
                            value: 'Select date',
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.people_outline_rounded,
                    label: 'TRAVELLERS & CLASS',
                    value: _travellers,
                    trailing: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Search Flights',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FROM', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(_fromCode, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, height: 1)),
                Text(_from, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _swapCities,
          child: RotationTransition(
            turns: _swapRotation,
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppTheme.brandGradient),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('TO', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(_toCode, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.primary, height: 1)),
                Text(_to, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- WhatsApp FAB with proper icon ---

class _WhatsAppFab extends StatelessWidget {
  final VoidCallback onTap;
  const _WhatsAppFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withValues(alpha: 0.50),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: CustomPaint(painter: _WhatsAppIconPainter()),
      ),
    );
  }
}

class _WhatsAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.36; // speech-bubble radius

    // Draw speech bubble circle
    canvas.drawCircle(Offset(cx, cy - 1), r, paint);

    // Speech bubble tail (bottom-left)
    final tail = Path()
      ..moveTo(cx - r * 0.5, cy + r * 0.7)
      ..lineTo(cx - r * 1.0, cy + r * 1.1)
      ..lineTo(cx - r * 0.1, cy + r * 0.75)
      ..close();
    canvas.drawPath(tail, paint);

    // Draw phone handset inside the bubble in green
    final phonePaint = Paint()
      ..color = const Color(0xFF25D366)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(cx, cy - 1);
    // Rotate 40° counter-clockwise to mimic WhatsApp handset angle
    canvas.rotate(-math.pi / 4.5);

    final s = size.width * 0.11; // scale factor for handset parts

    // Earpiece oval (top)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -s * 1.8), width: s * 1.7, height: s * 1.2),
      phonePaint,
    );
    // Connecting grip bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: s * 1.1, height: s * 2.6),
        Radius.circular(s * 0.4),
      ),
      phonePaint,
    );
    // Mouthpiece oval (bottom)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, s * 1.8), width: s * 1.7, height: s * 1.2),
      phonePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_) => false;
}

// --- Slider ---

class _SlideData {
  final IconData icon;
  final String title, subtitle;
  final List<Color> gradient;
  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class _SlideCard extends StatelessWidget {
  final _SlideData data;
  const _SlideCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.25),
                ),
                const SizedBox(height: 10),
                Text(
                  data.subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: Colors.white, size: 42),
          ),
        ],
      ),
    );
  }
}

// --- Flight path divider ---

class _FlightPathDivider extends StatelessWidget {
  final bool isRoundTrip;
  const _FlightPathDivider({required this.isRoundTrip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.divider, AppTheme.primary.withValues(alpha: 0.4)],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            isRoundTrip ? Icons.swap_horiz_rounded : Icons.flight_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
        ),
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary.withValues(alpha: 0.4), AppTheme.divider],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Sub-widgets ---

class _TripChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TripChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? AppTheme.primaryDark : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Widget? trailing;
  const _InfoTile({required this.icon, required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
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
