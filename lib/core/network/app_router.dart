import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../widgets/main_scaffold.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/booking/presentation/screens/bookings_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00A651),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff_rounded, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'GenFly',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fly Smart, Fly Easy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, __) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookings,
              builder: (_, __) => const BookingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.offers,
              builder: (_, __) => const OffersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.support,
              builder: (_, __) => const SupportScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
