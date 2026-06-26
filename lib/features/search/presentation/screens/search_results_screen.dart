import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/constants/app_routes.dart';

class SearchResultsScreen extends StatefulWidget {
  final String from, fromCode, to, toCode, date, travellers;

  const SearchResultsScreen({
    super.key,
    required this.from,
    required this.fromCode,
    required this.to,
    required this.toCode,
    required this.date,
    required this.travellers,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  int _selected = 1; // IndiGo selected by default

  static const _flights = [
    _FlightData(
      airline: 'Air India',
      initial: 'AI',
      airlineColor: Color(0xFFB71C1C),
      flightNo: 'AI-805 • Boeing 787',
      dep: '06:00', arr: '08:15',
      depCode: 'DEL', arrCode: 'BOM',
      duration: '2h 15m',
      stops: 'Non-stop',
      genFlyPrice: '₹4,200',
      isBestValue: false,
    ),
    _FlightData(
      airline: 'IndiGo',
      initial: 'I6',
      airlineColor: Color(0xFF1565C0),
      flightNo: '6E-2134 • Airbus A320',
      dep: '08:45', arr: '10:55',
      depCode: 'DEL', arrCode: 'BOM',
      duration: '2h 10m',
      stops: 'Non-stop',
      genFlyPrice: '₹3,900',
      isBestValue: true,
    ),
    _FlightData(
      airline: 'Akasa Air',
      initial: 'QP',
      airlineColor: Color(0xFFE65100),
      flightNo: 'QP-1102 • Boeing 737',
      dep: '14:20', arr: '16:35',
      depCode: 'DEL', arrCode: 'BOM',
      duration: '2h 15m',
      stops: 'Non-stop',
      genFlyPrice: '₹4,050',
      isBestValue: false,
    ),
    _FlightData(
      airline: 'SpiceJet',
      initial: 'SG',
      airlineColor: Color(0xFFDD2C00),
      flightNo: 'SG-123 • Boeing 737',
      dep: '19:40', arr: '22:00',
      depCode: 'DEL', arrCode: 'BOM',
      duration: '2h 20m',
      stops: 'Non-stop',
      genFlyPrice: '₹4,450',
      isBestValue: false,
    ),
  ];

  void _goToComparison() {
    final f = _flights[_selected];
    context.push(AppRoutes.flightComparison, extra: {
      'airline': f.airline,
      'initial': f.initial,
      'flightNo': f.flightNo,
      'dep': f.dep,
      'arr': f.arr,
      'depCode': f.depCode,
      'arrCode': f.arrCode,
      'duration': f.duration,
      'stops': f.stops,
      'genFlyPrice': f.genFlyPrice,
      'date': widget.date,
      'travellers': widget.travellers,
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = _flights[_selected];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 110),
        children: [
          _buildStepBar(),
          _buildSectionHeader(),
          ...List.generate(_flights.length, (i) => _FlightCard(
            data: _flights[i],
            isSelected: _selected == i,
            onTap: () => setState(() => _selected = i),
          )),
          const SizedBox(height: 20),
          _buildTrustBadges(),
          const SizedBox(height: 20),
          _buildHelpSection(),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(f),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Your Flight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Text(
            '${widget.fromCode} → ${widget.toCode}  •  ${widget.date}',
            style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildStepBar() {
    const steps = ['Route', 'Date', 'Airline', 'Compare', 'Book'];
    const current = 2;
    return Container(
      color: AppTheme.primaryDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: (i ~/ 2) < current ? AppTheme.secondary : Colors.white24,
              ),
            );
          }
          final idx = i ~/ 2;
          final isDone = idx < current;
          final isActive = idx == current;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppTheme.secondary : isActive ? Colors.white : Colors.transparent,
                  border: Border.all(color: isDone || isActive ? Colors.transparent : Colors.white38, width: 1.5),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded, size: 16, color: AppTheme.primaryDark)
                      : Text('${idx + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                          color: isActive ? AppTheme.primaryDark : Colors.white38)),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[idx], style: TextStyle(fontSize: 9,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isDone ? AppTheme.secondary : isActive ? Colors.white : Colors.white38)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Flights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('${widget.from} → ${widget.to}  •  ${widget.date}  •  ${widget.travellers}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    const badges = [
      (Icons.shield_outlined, 'No Hidden\nCharges'),
      (Icons.local_offer_outlined, 'Best Available\nFare'),
      (Icons.support_agent_outlined, 'Human\nAssistance'),
      (Icons.bolt_outlined, 'Instant\nConfirmation'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          children: badges.map((b) {
            final (icon, label) = b;
            return Expanded(
              child: Column(
                children: [
                  Icon(icon, color: AppTheme.primary, size: 28),
                  const SizedBox(height: 8),
                  Text(label, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary, fontWeight: FontWeight.w600, height: 1.4)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need help choosing?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            const Text('Our flight experts are available 24/7 to help you pick the best flight and fare.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _HelpButton(
                    label: 'WhatsApp',
                    icon: Icons.chat_rounded, // overridden by leadingWidget below
                    leadingWidget: const _ChatBubbleIcon(size: 20),
                    color: const Color(0xFF25D366),
                    onTap: _openWhatsApp,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HelpButton(
                    label: 'Call Us',
                    icon: Icons.call_rounded,
                    color: AppTheme.primaryDark,
                    onTap: _callSupport,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(_FlightData f) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.airline, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                Text('${f.dep} → ${f.arr}  •  ${f.duration}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _goToComparison,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Compare & Book'),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const phone = '919876543210';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent("Hi GenFly! I need help choosing a flight.")}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _callSupport() async {
    try {
      await launchUrl(Uri.parse('tel:+919876543210'));
    } catch (_) {}
  }
}

// ---------------------------------------------------------------------------
// Flight card — no price shown; price is internal for comparison screen
// ---------------------------------------------------------------------------

class _FlightCard extends StatelessWidget {
  final _FlightData data;
  final bool isSelected;
  final VoidCallback onTap;
  const _FlightCard({required this.data, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppTheme.primary.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top: airline circle + name + flight no + selection indicator
                  Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: data.airlineColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(data.initial,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: data.airlineColor)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.airline, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                            Text(data.flightNo, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppTheme.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.divider,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),

                  // Times + duration row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.dep, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(data.depCode, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(data.duration, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(child: Container(height: 1, color: AppTheme.divider)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Icon(Icons.flight_rounded, size: 16, color: AppTheme.primary),
                                ),
                                Expanded(child: Container(height: 1, color: AppTheme.divider)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(data.stops, style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(data.arr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(data.arrCode, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BEST VALUE badge — centered at top of card
            if (data.isBestValue)
              Positioned(
                top: 0, left: 0, right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 11, color: Colors.white),
                        SizedBox(width: 4),
                        Text('BEST VALUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _HelpButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Widget? leadingWidget;

  const _HelpButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leadingWidget ?? Icon(icon, size: 17),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}

// Speech bubble icon — proper chat bubble with tail, clearly reads as messaging
class _ChatBubbleIcon extends StatelessWidget {
  final double size;
  const _ChatBubbleIcon({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ChatBubblePainter(),
    );
  }
}

class _ChatBubblePainter extends CustomPainter {
  const _ChatBubblePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Body of the bubble occupies top 78% of the bounding box
    final bodyH = h * 0.78;
    const r = 3.5; // corner radius

    final path = Path()
      // top-left corner
      ..moveTo(r, 0)
      // top edge → top-right corner
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: const Radius.circular(r))
      // right edge → bottom-right corner
      ..lineTo(w, bodyH - r)
      ..arcToPoint(Offset(w - r, bodyH), radius: const Radius.circular(r))
      // bottom edge, right side → start of tail
      ..lineTo(w * 0.38, bodyH)
      // tail: curves down-left then back up (classic WhatsApp-style tail)
      ..quadraticBezierTo(w * 0.20, bodyH + 1, w * 0.14, h)
      ..quadraticBezierTo(w * 0.10, bodyH, r, bodyH)
      // bottom edge, left side → bottom-left corner
      ..arcToPoint(Offset(0, bodyH - r), radius: const Radius.circular(r))
      // left edge → top-left corner
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
      ..close();

    canvas.drawPath(path, paint);

    // Three dots inside the bubble to represent a chat/typing indicator
    final dotPaint = Paint()
      ..color = const Color(0xFF25D366)
      ..style = PaintingStyle.fill;
    const dotR = 1.4;
    final dotY = bodyH * 0.52;
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(w * (0.28 + i * 0.22), dotY),
        dotR,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ChatBubblePainter old) => false;
}

class _FlightData {
  final String airline, initial, flightNo, dep, arr, depCode, arrCode, duration, stops, genFlyPrice;
  final Color airlineColor;
  final bool isBestValue;

  const _FlightData({
    required this.airline,
    required this.initial,
    required this.airlineColor,
    required this.flightNo,
    required this.dep,
    required this.arr,
    required this.depCode,
    required this.arrCode,
    required this.duration,
    required this.stops,
    required this.genFlyPrice,
    required this.isBestValue,
  });
}
