import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/main_scaffold.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/booking/presentation/screens/bookings_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/search/presentation/screens/search_results_screen.dart';
import '../../features/search/presentation/screens/flight_comparison_screen.dart';

// Root navigator key — required so routes pushed from inside StatefulShellRoute
// are placed on the root navigator, not the branch's sub-navigator.
final GlobalKey<NavigatorState> _rootNavKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// ---------------------------------------------------------------------------
// Splash screen
// ---------------------------------------------------------------------------
//
// Straight vertical flight: plane rises from below screen to above.
// Icons.flight_rounded default = NE (45° upper-right).
// Rotate -pi/4 (45° CCW) → icon points straight up (North). No guessing.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _dots;

  late final Animation<double> _contentFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _planeProg;

  @override
  void initState() {
    super.initState();

    _main = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _dots = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat();

    // Everything fades in together on the very first frame
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _main,
            curve: const Interval(0.0, 0.20, curve: Curves.easeOut)));

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(
            parent: _main,
            curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack)));

    // Plane flies bottom→top over full animation window
    _planeProg = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _main, curve: const Interval(0.0, 1.0)));

    _main.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _main.dispose();
    _dots.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const iconHalf = 22.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Solid #0D3B2E matches the native Android splash exactly —
        // no visible colour jump when Flutter takes over.
        color: const Color(0xFF0D3B2E),
        child: Stack(
          children: [
            // Airplane: straight up, nose pointing north
            AnimatedBuilder(
              animation: _planeProg,
              builder: (_, __) {
                final p = _planeProg.value;
                // Enter from 10% below screen, exit 10% above screen
                final y = size.height * (1.10 - p * 1.25) - iconHalf;
                final x = size.width / 2 - iconHalf;
                // Fade in first 10%, fade out last 20%
                final opacity = p < 0.10
                    ? p / 0.10
                    : p > 0.80
                        ? (1.0 - p) / 0.20
                        : 1.0;
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      // NE default icon → rotate -pi/4 → points straight up
                      angle: -math.pi / 4,
                      child: Icon(
                        Icons.flight_rounded,
                        color: Colors.white.withValues(alpha: 0.90),
                        size: 44,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Logo + brand + tagline — all fade in together immediately
            FadeTransition(
              opacity: _contentFade,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset(
                        'assets/images/New_logo.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'GenFly',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Fly Smart. Fly Easy.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pulsing dots at the bottom
            Positioned(
              bottom: 54,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _dots,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final phase =
                        ((_dots.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                    final op = 0.20 + 0.80 * math.sin(phase * math.pi);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: op),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
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
// Page transitions
// ---------------------------------------------------------------------------

Page<T> _fadeSlidePage<T>(
    {required Widget child, required GoRouterState state}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final slide =
          Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeSec = Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(
              parent: secondaryAnimation, curve: Curves.easeInCubic));
      return FadeTransition(
        opacity: fadeSec,
        child: FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child)),
      );
    },
  );
}

Page<T> _slideRightPage<T>(
    {required Widget child, required GoRouterState state}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn =
          Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeSec = Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(
              parent: secondaryAnimation, curve: Curves.easeInCubic));
      return FadeTransition(
          opacity: fadeSec,
          child: SlideTransition(position: slideIn, child: child));
    },
  );
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // Splash — no parentNavigatorKey needed (runs before shell exists)
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) =>
          _fadeSlidePage(child: const SplashScreen(), state: state),
    ),

    // Full-screen routes pushed from inside the shell — MUST use root navigator
    GoRoute(
      path: AppRoutes.notifications,
      parentNavigatorKey: _rootNavKey,
      pageBuilder: (context, state) =>
          _slideRightPage(child: const NotificationsScreen(), state: state),
    ),
    GoRoute(
      path: AppRoutes.searchResults,
      parentNavigatorKey: _rootNavKey,
      pageBuilder: (context, state) {
        final e = (state.extra as Map<String, String>?) ?? {};
        return _slideRightPage(
          child: SearchResultsScreen(
            from: e['from'] ?? 'Delhi',
            fromCode: e['fromCode'] ?? 'DEL',
            to: e['to'] ?? 'Mumbai',
            toCode: e['toCode'] ?? 'BOM',
            date: e['date'] ?? '',
            travellers: e['travellers'] ?? '1 Adult, Economy',
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.flightComparison,
      parentNavigatorKey: _rootNavKey,
      pageBuilder: (context, state) {
        final e = (state.extra as Map<String, String>?) ?? {};
        return _slideRightPage(
          child: FlightComparisonScreen(
            airline: e['airline'] ?? '',
            initial: e['initial'] ?? '',
            flightNo: e['flightNo'] ?? '',
            dep: e['dep'] ?? '',
            arr: e['arr'] ?? '',
            depCode: e['depCode'] ?? 'DEL',
            arrCode: e['arrCode'] ?? 'BOM',
            duration: e['duration'] ?? '',
            stops: e['stops'] ?? '',
            genFlyPrice: e['genFlyPrice'] ?? '',
            date: e['date'] ?? '',
            travellers: e['travellers'] ?? '',
          ),
          state: state,
        );
      },
    ),

    // Bottom-nav shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                _fadeSlidePage(child: const HomeScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.bookings,
            pageBuilder: (context, state) =>
                _fadeSlidePage(child: const BookingsScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.offers,
            pageBuilder: (context, state) =>
                _fadeSlidePage(child: const OffersScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.support,
            pageBuilder: (context, state) =>
                _fadeSlidePage(child: const SupportScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                _fadeSlidePage(child: const ProfileScreen(), state: state),
          ),
        ]),
      ],
    ),
  ],
);
