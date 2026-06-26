import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class FlightComparisonScreen extends StatelessWidget {
  final String airline, initial, flightNo;
  final String dep, arr, depCode, arrCode, duration, stops;
  final String genFlyPrice, date, travellers;

  const FlightComparisonScreen({
    super.key,
    required this.airline,
    required this.initial,
    required this.flightNo,
    required this.dep,
    required this.arr,
    required this.depCode,
    required this.arrCode,
    required this.duration,
    required this.stops,
    required this.genFlyPrice,
    required this.date,
    required this.travellers,
  });

  // Competitor prices always higher than GenFly
  List<_PriceRow> get _comparisons => [
    const _PriceRow(platform: 'MakeMyTrip', price: '₹4,800', logoColor: Color(0xFFE53935)),
    const _PriceRow(platform: 'Goibibo', price: '₹4,650', logoColor: Color(0xFF1565C0)),
    const _PriceRow(platform: 'EaseMyTrip', price: '₹4,500', logoColor: Color(0xFF6A1B9A)),
    const _PriceRow(platform: 'Ixigo', price: '₹4,250', logoColor: Color(0xFFF57C00)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Compare Prices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('$depCode → $arrCode  •  $date',
                style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w400)),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 110),
        children: [
          _buildStepBar(),
          _buildFlightHeader(),
          _buildComparisonTable(),
          const SizedBox(height: 20),
          _buildWhyGenFly(),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: _buildProceedBar(context),
    );
  }

  Widget _buildStepBar() {
    const steps = ['Route', 'Date', 'Airline', 'Compare', 'Book'];
    const current = 3; // Compare
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

  Widget _buildFlightHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Airline initial circle
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0), // matches IndiGo default; would be dynamic in real app
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(initial,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(airline, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  Text(flightNo, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.brandGradient),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Price Comparison', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Spacer(),
                  Text('Same flight, same route', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),

            // Competitor rows
            ..._comparisons.map((row) => _CompetitorRow(row: row)),

            const Divider(height: 1, indent: 20, endIndent: 20),

            // GenFly row — highlighted
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                    child: const Center(
                      child: Text('GF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GenFly', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('You\'re on the best price!', style: TextStyle(fontSize: 10, color: Colors.white60)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(genFlyPrice, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('LOWEST', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.primary, letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Savings summary
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.savings_outlined, color: AppTheme.primary, size: 18),
                    SizedBox(width: 8),
                    Text('You save up to ₹900 vs MakeMyTrip', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyGenFly() {
    const points = [
      (Icons.no_encryption_outlined, 'Zero Hidden Convenience Fee'),
      (Icons.price_check_rounded, 'Price Match Guarantee'),
      (Icons.flash_on_rounded, 'Instant Booking Confirmation'),
      (Icons.support_agent_rounded, '24/7 Expert Travel Support'),
      (Icons.credit_card_rounded, 'Instant EMI with 0% Interest'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why book with GenFly?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 14),
            ...points.map((p) {
              final (icon, text) = p;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                      child: Icon(icon, size: 16, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
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
                const Text('GenFly Price', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                Text(genFlyPrice, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking flow coming soon!'), backgroundColor: AppTheme.primaryDark),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 4,
              shadowColor: AppTheme.primary.withValues(alpha: 0.4),
            ),
            child: const Text('Proceed to Book', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _PriceRow {
  final String platform, price;
  final Color logoColor;
  const _PriceRow({required this.platform, required this.price, required this.logoColor});
}

class _CompetitorRow extends StatelessWidget {
  final _PriceRow row;
  const _CompetitorRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: row.logoColor.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Center(
              child: Text(row.platform[0],
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: row.logoColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(row.platform, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
          ),
          Text(row.price,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough, decorationColor: Colors.grey[400])),
        ],
      ),
    );
  }
}
