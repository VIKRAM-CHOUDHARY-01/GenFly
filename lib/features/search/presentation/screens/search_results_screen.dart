import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/theme/app_theme.dart';

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
  int _selected = 1; // IndiGo selected by default (best value)

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
      price: '₹4,200',
      saving: 'Save ₹600',
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
      price: '₹3,900',
      saving: 'Save ₹600',
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
      price: '₹4,050',
      saving: 'Save ₹550',
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
      price: '₹4,450',
      saving: 'Save ₹450',
      isBestValue: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _flights[_selected];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _buildStepBar(),
          _buildSectionHeader(),
          ...List.generate(_flights.length, (i) => _FlightCard(
            data: _flights[i],
            isSelected: _selected == i,
            onTap: () => setState(() => _selected = i),
          )),
          const SizedBox(height: 12),
          _buildLiveComparison(selected),
          const SizedBox(height: 20),
          _buildTrustBadges(),
          const SizedBox(height: 20),
          _buildHelpSection(),
          const SizedBox(height: 20),
        ],
      ),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          onPressed: () {},
          tooltip: 'Filter',
        ),
      ],
      elevation: 0,
    );
  }

  Widget _buildStepBar() {
    const steps = ['Route', 'Date', 'Airline', 'Compare', 'Book'];
    const current = 2; // Airline step
    return Container(
      color: AppTheme.primaryDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            final stepIdx = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIdx < current ? AppTheme.secondary : Colors.white24,
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final isDone = stepIdx < current;
          final isActive = stepIdx == current;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppTheme.secondary : isActive ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isDone || isActive ? Colors.transparent : Colors.white38,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded, size: 16, color: AppTheme.primaryDark)
                      : Text(
                          '${stepIdx + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isActive ? AppTheme.primaryDark : Colors.white38,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIdx],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isDone ? AppTheme.secondary : isActive ? Colors.white : Colors.white38,
                ),
              ),
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
          Text(
            'Select Your Flight',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.from} (${widget.fromCode}) → ${widget.to} (${widget.toCode})  •  ${widget.date}',
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveComparison(_FlightData f) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows_rounded, color: AppTheme.primary, size: 22),
                const SizedBox(width: 8),
                const Text('Live Comparison', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Selected: ${f.airline}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),

            // Other apps row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Other Apps', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  Text('₹4,500', style: TextStyle(fontSize: 13, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Our price row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Our Price', style: TextStyle(fontSize: 11, color: Colors.white60)),
                      Text('₹3,900', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Discount applied
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.local_offer_rounded, size: 16, color: AppTheme.primary),
                  SizedBox(width: 6),
                  Text('Discount Applied: ₹600', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _CheckRow('No Hidden Convenience Fee'),
            const SizedBox(height: 6),
            _CheckRow('Instant EMI Eligibility'),
            const SizedBox(height: 18),

            // Continue to Book
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: const Text('Continue to Book'),
              ),
            ),
          ],
        ),
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
                  Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary, fontWeight: FontWeight.w600, height: 1.4)),
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
            const Text('Need Help with your booking?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            const Text('Our flight experts are available 24/7 to assist you with the best routes and fares.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5)),
            const SizedBox(height: 16),
            // WhatsApp
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _openWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Call
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _callSupport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Call Support', style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const phone = '919876543210';
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent("Hi GenFly! I need help with my booking.")}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _callSupport() async {
    final uri = Uri.parse('tel:+919876543210');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }
}

// ---------------------------------------------------------------------------
// Flight card
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
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
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
                  // Top row: airline info + price
                  Row(
                    children: [
                      // Airline circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: data.airlineColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(data.initial,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: data.airlineColor)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.airline, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                            Text(data.flightNo, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(data.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Row(
                            children: [
                              const Icon(Icons.arrow_downward_rounded, size: 11, color: AppTheme.primary),
                              const SizedBox(width: 2),
                              Text(data.saving, style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),

                  // Bottom row: times + duration
                  Row(
                    children: [
                      // Departure
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.dep, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(data.depCode, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      // Duration line
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
                            Text(data.stops, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      // Arrival
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(data.arr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                          Text(data.arrCode, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BEST VALUE badge
            if (data.isBestValue)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, size: 12, color: Colors.white),
                      SizedBox(width: 3),
                      Text('BEST VALUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                    ],
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
// Small helpers
// ---------------------------------------------------------------------------

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _FlightData {
  final String airline, initial, flightNo, dep, arr, depCode, arrCode, duration, stops, price, saving;
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
    required this.price,
    required this.saving,
    required this.isBestValue,
  });
}
