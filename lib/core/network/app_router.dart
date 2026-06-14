import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';

// Screens will be imported here as they are built
// Placeholder screens until real ones are implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text('$title — Coming Soon')),
      );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 72, color: Color(0xFF0057FF)),
            SizedBox(height: 16),
            Text(
              'GenFly',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0057FF)),
            ),
            SizedBox(height: 8),
            Text('Fly Smart, Fly Easy', style: TextStyle(fontSize: 16, color: Color(0xFF6C757D))),
          ],
        ),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const _PlaceholderScreen('Login')),
    GoRoute(path: AppRoutes.register, builder: (_, __) => const _PlaceholderScreen('Register')),
    GoRoute(path: AppRoutes.otpVerification, builder: (_, __) => const _PlaceholderScreen('OTP Verification')),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const _PlaceholderScreen('Home')),
    GoRoute(path: AppRoutes.searchResults, builder: (_, __) => const _PlaceholderScreen('Search Results')),
    GoRoute(path: AppRoutes.flightDetails, builder: (_, __) => const _PlaceholderScreen('Flight Details')),
    GoRoute(path: AppRoutes.seatSelection, builder: (_, __) => const _PlaceholderScreen('Seat Selection')),
    GoRoute(path: AppRoutes.passengerDetails, builder: (_, __) => const _PlaceholderScreen('Passenger Details')),
    GoRoute(path: AppRoutes.reviewBooking, builder: (_, __) => const _PlaceholderScreen('Review Booking')),
    GoRoute(path: AppRoutes.payment, builder: (_, __) => const _PlaceholderScreen('Payment')),
    GoRoute(path: AppRoutes.paymentSuccess, builder: (_, __) => const _PlaceholderScreen('Payment Success')),
    GoRoute(path: AppRoutes.paymentFailure, builder: (_, __) => const _PlaceholderScreen('Payment Failed')),
    GoRoute(path: AppRoutes.bookingHistory, builder: (_, __) => const _PlaceholderScreen('Booking History')),
    GoRoute(path: AppRoutes.bookingDetails, builder: (_, __) => const _PlaceholderScreen('Booking Details')),
    GoRoute(path: AppRoutes.ticket, builder: (_, __) => const _PlaceholderScreen('Ticket')),
    GoRoute(path: AppRoutes.profile, builder: (_, __) => const _PlaceholderScreen('Profile')),
    GoRoute(path: AppRoutes.notifications, builder: (_, __) => const _PlaceholderScreen('Notifications')),
  ],
);
