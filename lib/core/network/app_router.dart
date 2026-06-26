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

// ---------------------------------------------------------------------------
// Plane physics helpers — used by both the icon widget and the contrail painter
// ---------------------------------------------------------------------------

// Phase 0–0.44: runway roll — plane accelerates horizontally (easeIn)
// Phase 0.44–1.0: airborne — constant horizontal speed
// Ground level: 73% from top of screen
double _planeX(double t, double w) {
  if (t < 0.44) {
    return (-0.50 + Curves.easeIn.transform(t / 0.44) * 0.95) * w;
  }
  return (0.45 + ((t - 0.44) / 0.56) * 1.30) * w;
}

double _planeY(double t, double h) {
  const groundFrac = 0.73;
  if (t < 0.52) return groundFrac * h;
  // easeOut: fast initial climb (steep nose-up), then levels off
  final ct = (t - 0.52) / 0.48;
  return (groundFrac - Curves.easeOut.transform(ct) * 0.62) * h;
}

// Angle is computed from instantaneous velocity so the nose ALWAYS points
// where the plane is actually going. Icons.flight_rounded default = NE (45°),
// so Flutter rotation r = π/4 − θ where θ is velocity direction from east.
double _planeAngle(double t, double w, double h) {
  const dt = 0.008;
  final t1 = (t + dt).clamp(0.0, 0.994);
  final dx = _planeX(t1, w) - _planeX(t, w);
  final dy = _planeY(t1, h) - _planeY(t, h);
  if (dx.abs() < 0.1) return math.pi / 4;
  // atan2(-dy, dx): screen y is inverted so negate dy to get standard math angle
  return math.pi / 4 - math.atan2(-dy, dx);
}

// ---------------------------------------------------------------------------
// Splash screen — single seamless screen, matches native splash green exactly
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Main timeline: logo → text → plane (2200ms)
  late final AnimationController _main;
  // Dot pulse loop (independent)
  late final AnimationController _dots;

  // Logo: elastic scale-up from center (no slide — matches plain-green native splash)
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // "GenFly" text slides in from right
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // Tagline fades in
  late final Animation<double> _tagFade;

  // Plane sweeps diagonally across the screen
  late final Animation<double> _planeProg; // 0→1 drives parametric position
  late final Animation<double> _planeFade;

  @override
  void initState() {
    super.initState();

    _main = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
    _dots = AnimationController(vsync: this, duration: const Duration(milliseconds: 750))..repeat();

    // Logo pops in from center with elastic bounce
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.0, 0.50, curve: Curves.elasticOut)));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.0, 0.18, curve: Curves.easeOut)));

    // Brand name slides in from the right
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.28, 0.50, curve: Curves.easeOut)));
    _textSlide = Tween<Offset>(begin: const Offset(0.35, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.28, 0.52, curve: Curves.easeOutCubic)));

    // Tagline
    _tagFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.46, 0.65, curve: Curves.easeOut)));

    // Plane drives takeoff physics: linear t, all easing is inside _planeX/_planeY/_planeAngle
    _planeProg = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.10, 0.90)));
    _planeFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.82, 0.94, curve: Curves.easeIn)));

    _main.forward();

    Future.delayed(const Duration(milliseconds: 4000), () {
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
        // Identical gradient to @color/splash_background — no visual seam
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF071E12), Color(0xFF0D3B2E), Color(0xFF0A2E20)],
          ),
        ),
        child: Stack(
          children: [
            // Faint background clouds for depth
            ..._buildClouds(size),

            // Animated airplane — runs physics-correct takeoff
            AnimatedBuilder(
              animation: _main,
              builder: (_, __) {
                final t = _planeProg.value;
                final x = _planeX(t, size.width);
                final y = _planeY(t, size.height);
                final angle = _planeAngle(t, size.width, size.height);
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: _planeFade.value.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Icon(
                        Icons.flight_rounded,
                        color: Colors.white.withValues(alpha: 0.92),
                        size: 44,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Plane contrail (trail of fading dots along arc)
            AnimatedBuilder(
              animation: _planeProg,
              builder: (_, __) => CustomPaint(
                size: size,
                painter: _ContrailPainter(progress: _planeProg.value),
              ),
            ),

            // Center: logo + brand name + tagline
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo — scales from center, elastic bounce
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

                  // "GenFly" slides in from right
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

                  // Tagline
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

            // Pulsing loading dots at the bottom
            Positioned(
              bottom: 54,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _dots,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final phase = ((_dots.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                    final opacity = 0.20 + 0.80 * math.sin(phase * math.pi);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: opacity),
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
        child: Icon(
          Icons.cloud_rounded,
          size: sz,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
    }).toList();
  }
}

// Draws the plane's fading contrail — uses the same physics as the plane icon
class _ContrailPainter extends CustomPainter {
  final double progress;
  const _ContrailPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.04) return;

    const trailCount = 14;
    const iconHalf = 22.0; // half of icon size (44px) to centre the dot on the icon
    for (int i = 1; i <= trailCount; i++) {
      final t = (progress - i * 0.025).clamp(0.0, 1.0);
      if (t <= 0) break;
      final x = _planeX(t, size.width) + iconHalf;
      final y = _planeY(t, size.height) + iconHalf;
      final alpha = (1 - i / trailCount) * 0.20 * progress;
      final radius = (1 - i / trailCount) * 3.0;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = Colors.white.withValues(alpha: alpha.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(_ContrailPainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------
// Page transitions
// ---------------------------------------------------------------------------

Page<T> _fadeSlidePage<T>({required Widget child, required GoRouterState state}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeSec = Tween<double>(begin: 1.0, end: 0.92)
          .animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));
      return FadeTransition(
        opacity: fadeSec,
        child: FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child)),
      );
    },
  );
}

Page<T> _slideRightPage<T>({required Widget child, required GoRouterState state}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn = Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeSec = Tween<double>(begin: 1.0, end: 0.92)
          .animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));
      return FadeTransition(opacity: fadeSec, child: SlideTransition(position: slideIn, child: child));
    },
  );
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => _fadeSlidePage(child: const SplashScreen(), state: state),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      pageBuilder: (context, state) => _slideRightPage(child: const NotificationsScreen(), state: state),
    ),
    GoRoute(
      path: AppRoutes.searchResults,
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _fadeSlidePage(child: const HomeScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.bookings,
            pageBuilder: (context, state) => _fadeSlidePage(child: const BookingsScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.offers,
            pageBuilder: (context, state) => _fadeSlidePage(child: const OffersScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.support,
            pageBuilder: (context, state) => _fadeSlidePage(child: const SupportScreen(), state: state),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => _fadeSlidePage(child: const ProfileScreen(), state: state),
          ),
        ]),
      ],
    ),
  ],
);
