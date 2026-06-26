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
  // Search state
  String _from = 'Delhi';
  String _fromCode = 'DEL';
  String _to = 'Mumbai';
  String _toCode = 'BOM';
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  bool _isRoundTrip = false;

  // Travellers
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _cabinClass = 'Economy';

  // Swap animation
  late AnimationController _swapController;
  late Animation<double> _swapRotation;

  // Promo slider
  final PageController _sliderController = PageController();
  int _currentSlide = 0;
  Timer? _sliderTimer;

  String get _travellers {
    final total = _adults + _children + _infants;
    return '$total ${total == 1 ? 'Traveller' : 'Travellers'}, $_cabinClass';
  }

  String get _dateLabel {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${_departureDate.day} ${months[_departureDate.month - 1]} ${_departureDate.year}';
  }

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
      _sliderController.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
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
      final tempCity = _from; _from = _to; _to = tempCity;
      final tempCode = _fromCode; _fromCode = _toCode; _toCode = tempCode;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _departureDate.isBefore(now) ? now : _departureDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            onSurface: AppTheme.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _departureDate = picked);
  }

  Future<void> _pickTravellers() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TravellersSheet(
        adults: _adults,
        children: _children,
        infants: _infants,
        cabinClass: _cabinClass,
        onApply: (a, c, i, cls) => setState(() {
          _adults = a; _children = c; _infants = i; _cabinClass = cls;
        }),
      ),
    );
  }

  void _searchFlights() {
    context.push(AppRoutes.searchResults, extra: {
      'from': _from,
      'fromCode': _fromCode,
      'to': _to,
      'toCode': _toCode,
      'date': _dateLabel,
      'travellers': _travellers,
    });
  }

  Future<void> _openWhatsApp() async {
    const phone = '919876543210';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent("Hi GenFly! I need help with my booking.")}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
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
      toolbarHeight: 72,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      titleSpacing: 4.0,
      title: Image.asset('assets/images/New_logo.png', height: 64, fit: BoxFit.contain),
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
            bottom: 14, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentSlide == i ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentSlide == i ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            // Gradient trip toggle header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.brandGradient),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  _TripChip(label: 'One Way', selected: !_isRoundTrip, onTap: () => setState(() => _isRoundTrip = false)),
                  const SizedBox(width: 10),
                  _TripChip(label: 'Round Trip', selected: _isRoundTrip, onTap: () => setState(() => _isRoundTrip = true)),
                  const Spacer(),
                  const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Large airport code row
                  _buildCityRow(),
                  const SizedBox(height: 16),
                  _FlightPathDivider(isRoundTrip: _isRoundTrip),
                  const SizedBox(height: 16),

                  // Date row
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.calendar_today_rounded,
                          label: 'DEPARTURE',
                          value: _dateLabel,
                          onTap: _pickDate,
                        ),
                      ),
                      if (_isRoundTrip) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.event_available_rounded,
                            label: 'RETURN',
                            value: 'Select date',
                            onTap: _pickDate,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Travellers
                  _InfoTile(
                    icon: Icons.people_outline_rounded,
                    label: 'TRAVELLERS & CLASS',
                    value: _travellers,
                    onTap: _pickTravellers,
                    trailing: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 18),

                  // Search button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _searchFlights,
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
                          Text('Search Flights', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
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
                boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
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

// ---------------------------------------------------------------------------
// Travellers bottom sheet
// ---------------------------------------------------------------------------

class _TravellersSheet extends StatefulWidget {
  final int adults, children, infants;
  final String cabinClass;
  final void Function(int adults, int children, int infants, String cabinClass) onApply;

  const _TravellersSheet({
    required this.adults,
    required this.children,
    required this.infants,
    required this.cabinClass,
    required this.onApply,
  });

  @override
  State<_TravellersSheet> createState() => _TravellersSheetState();
}

class _TravellersSheetState extends State<_TravellersSheet> {
  late int _adults;
  late int _children;
  late int _infants;
  late String _cabinClass;

  static const _classes = ['Economy', 'Premium Economy', 'Business', 'First Class'];

  @override
  void initState() {
    super.initState();
    _adults = widget.adults;
    _children = widget.children;
    _infants = widget.infants;
    _cabinClass = widget.cabinClass;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            width: 44,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const Text('Travellers & Class', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 20),

          // Counter rows
          _CounterRow(label: 'Adults', sub: '12+ yrs', value: _adults, min: 1, max: 9,
              onChanged: (v) => setState(() => _adults = v)),
          _CounterRow(label: 'Children', sub: '2–11 yrs', value: _children, max: 6,
              onChanged: (v) => setState(() => _children = v)),
          _CounterRow(label: 'Infants', sub: 'Under 2', value: _infants, max: _adults,
              onChanged: (v) => setState(() => _infants = v)),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Divider(height: 1),
          ),

          // Cabin class chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cabin Class', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _classes.map((cls) => _ClassChip(
                    label: cls,
                    selected: _cabinClass == cls,
                    onTap: () => setState(() => _cabinClass = cls),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Apply button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_adults, _children, _infants, _cabinClass);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Apply'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label, sub;
  final int value, max;
  final int min;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.label,
    required this.sub,
    required this.value,
    required this.max,
    required this.onChanged,
    this.min = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          _CounterButton(
            icon: Icons.remove_rounded,
            enabled: value > min,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 40,
            child: Text('$value', textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ),
          _CounterButton(
            icon: Icons.add_rounded,
            enabled: value < max,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? AppTheme.primary.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 18, color: enabled ? AppTheme.primary : Colors.grey[400]),
      ),
    );
  }
}

class _ClassChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ClassChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.textSecondary)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WhatsApp FAB
// ---------------------------------------------------------------------------

class _WhatsAppFab extends StatelessWidget {
  final VoidCallback onTap;
  const _WhatsAppFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58, height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFF25D366).withValues(alpha: 0.50), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: CustomPaint(painter: _WhatsAppIconPainter()),
      ),
    );
  }
}

class _WhatsAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.36;

    canvas.drawCircle(Offset(cx, cy - 1), r, paint);
    final tail = Path()
      ..moveTo(cx - r * 0.5, cy + r * 0.7)
      ..lineTo(cx - r * 1.0, cy + r * 1.1)
      ..lineTo(cx - r * 0.1, cy + r * 0.75)
      ..close();
    canvas.drawPath(tail, paint);

    final phonePaint = Paint()..color = const Color(0xFF25D366)..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(cx, cy - 1);
    canvas.rotate(-math.pi / 4.5);
    final s = size.width * 0.11;
    canvas.drawOval(Rect.fromCenter(center: Offset(0, -s * 1.8), width: s * 1.7, height: s * 1.2), phonePaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: s * 1.1, height: s * 2.6), Radius.circular(s * 0.4)), phonePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(0, s * 1.8), width: s * 1.7, height: s * 1.2), phonePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_) => false;
}

// ---------------------------------------------------------------------------
// Slider widgets
// ---------------------------------------------------------------------------

class _SlideData {
  final IconData icon;
  final String title, subtitle;
  final List<Color> gradient;
  const _SlideData({required this.icon, required this.title, required this.subtitle, required this.gradient});
}

class _SlideCard extends StatelessWidget {
  final _SlideData data;
  const _SlideCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: data.gradient),
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
                Text(data.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.25)),
                const SizedBox(height: 10),
                Text(data.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.55)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 82, height: 82,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(data.icon, color: Colors.white, size: 42),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search card sub-widgets
// ---------------------------------------------------------------------------

class _FlightPathDivider extends StatelessWidget {
  final bool isRoundTrip;
  const _FlightPathDivider({required this.isRoundTrip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1.5, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.divider, AppTheme.primary.withValues(alpha: 0.4)])))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(isRoundTrip ? Icons.swap_horiz_rounded : Icons.flight_rounded, color: AppTheme.primary, size: 22),
        ),
        Expanded(child: Container(height: 1.5, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.4), AppTheme.divider])))),
      ],
    );
  }
}

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
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? AppTheme.primaryDark : Colors.white70)),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _InfoTile({required this.icon, required this.label, required this.value, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
