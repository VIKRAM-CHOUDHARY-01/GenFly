import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.secondary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcoming(),
          _buildPast(),
        ],
      ),
    );
  }

  Widget _buildUpcoming() {
    final bookings = [
      _BookingData('GF-20261842', 'Delhi', 'Mumbai', 'DEL', 'BOM', '28 Jun 2026', '06:15', '08:30', '2h 15m', '₹4,299', 'CONFIRMED', true),
      _BookingData('GF-20261901', 'Mumbai', 'Goa', 'BOM', 'GOI', '05 Jul 2026', '10:00', '11:15', '1h 15m', '₹2,899', 'CONFIRMED', true),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(data: bookings[i]),
    );
  }

  Widget _buildPast() {
    final bookings = [
      _BookingData('GF-20260523', 'Bengaluru', 'Hyderabad', 'BLR', 'HYD', '10 May 2026', '14:30', '15:45', '1h 15m', '₹2,199', 'COMPLETED', false),
      _BookingData('GF-20260312', 'Delhi', 'Kolkata', 'DEL', 'CCU', '15 Mar 2026', '07:00', '09:30', '2h 30m', '₹3,599', 'COMPLETED', false),
      _BookingData('GF-20260201', 'Chennai', 'Delhi', 'MAA', 'DEL', '01 Feb 2026', '22:00', '01:00', '3h 00m', '₹4,999', 'CANCELLED', false),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(data: bookings[i]),
    );
  }
}

class _BookingData {
  final String pnr, fromCity, toCity, from, to, date, dep, arr, duration, price, status;
  final bool isUpcoming;
  const _BookingData(this.pnr, this.fromCity, this.toCity, this.from, this.to, this.date, this.dep, this.arr, this.duration, this.price, this.status, this.isUpcoming);
}

class _BookingCard extends StatelessWidget {
  final _BookingData data;
  const _BookingCard({required this.data});

  Color get _statusColor {
    return switch (data.status) {
      'CONFIRMED' => AppTheme.primary,
      'COMPLETED' => AppTheme.textSecondary,
      'CANCELLED' => AppTheme.error,
      _ => AppTheme.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PNR: ${data.pnr}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.5)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(data.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor)),
                ),
              ],
            ),
          ),
          // Flight info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _TimeBlock(time: data.dep, city: data.from, cityName: data.fromCity),
                Expanded(
                  child: Column(
                    children: [
                      Text(data.duration, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const SizedBox(width: 4),
                        Expanded(child: Container(height: 1.5, color: AppTheme.divider)),
                        const Icon(Icons.flight_rounded, size: 16, color: AppTheme.primary),
                        Expanded(child: Container(height: 1.5, color: AppTheme.divider)),
                        const SizedBox(width: 4),
                      ]),
                      const SizedBox(height: 4),
                      Text(data.date, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                _TimeBlock(time: data.arr, city: data.to, cityName: data.toCity, align: CrossAxisAlignment.end),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                if (data.isUpcoming)
                  TextButton(
                    onPressed: () {},
                    child: const Text('View Ticket', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                  )
                else
                  TextButton(
                    onPressed: () {},
                    child: const Text('Rebook', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String time, city, cityName;
  final CrossAxisAlignment align;
  const _TimeBlock({required this.time, required this.city, required this.cityName, this.align = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primary)),
        Text(cityName, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
