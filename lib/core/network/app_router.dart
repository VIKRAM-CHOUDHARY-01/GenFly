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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _dots;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _tagFade;

  @override
  void initState() {
    super.initState();

    _main = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800));
    _dots = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat();

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _main,
            curve: const Interval(0.0, 0.48, curve: Curves.elasticOut)));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _main,
            curve: const Interval(0.0, 0.16, curve: Curves.easeOut)));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _main,
            curve: const Interval(0.26, 0.46, curve: Curves.easeOut)));
    _textSlide =
        Tween<Offset>(begin: const Offset(0.35, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _main,
                curve: const Interval(0.26, 0.48, curve: Curves.easeOutCubic)));

    _tagFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _main,
        curve: const Interval(0.42, 0.60, curve: Curves.easeOut)));

    _main.forward();

    Future.delayed(const Duration(milliseconds: 3300), () {
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF071E12), Color(0xFF0D3B2E), Color(0xFF0A2E20)],
          ),
        ),
        child: Stack(
          children: [
            ..._buildClouds(size),

            // Logo + brand + tagline — staggered entrance
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        'assets/images/New_logo.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: const Text(
                        'GenFly',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _tagFade,
                    child: const Text(
                      'Fly Smart. Fly Easy.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
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

  List<Widget> _buildClouds(Size size) {
    const specs = [
      (0.06, 0.10, 80.0, 0.04),
      (0.70, 0.07, 95.0, 0.035),
      (0.80, 0.30, 60.0, 0.05),
      (0.10, 0.45, 70.0, 0.03),
      (0.50, 0.65, 55.0, 0.04),
      (0.30, 0.80, 75.0, 0.03),
    ];
    return specs.map((s) {
      final (dx, dy, sz, alpha) = s;
      return Positioned(
        left: dx * size.width,
        top: dy * size.height,
        child: Icon(Icons.cloud_rounded,
            size: sz, color: Colors.white.withValues(alpha: alpha)),
      );
    }).toList();
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
