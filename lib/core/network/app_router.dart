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

// ---------------------------------------------------------------------------
// Animated splash — airplane takeoff sequence
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Main timeline: logo fade-in, runway draw, plane roll + lift-off (2400ms)
  late final AnimationController _main;
  // Dots: repeat pulse independent of main (700ms)
  late final AnimationController _dots;

  // Logo
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;

  // "GenFly" text
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // Tagline
  late final Animation<double> _tagFade;

  // Runway
  late final Animation<double> _runwayProgress;

  // Airplane
  late final Animation<double> _planeX;      // fraction of screen width, -0.7 → 1.8
  late final Animation<double> _planeY;      // fraction of screen height, 0 → -0.4
  late final Animation<double> _planeAngle;  // radians, 0 → -π/5
  late final Animation<double> _planeScale;  // 1.0 → 1.5
  late final Animation<double> _planeFade;   // 1.0 → 0.0 (exit fade)

  @override
  void initState() {
    super.initState();

    _main = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    _dots = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat();

    _logoFade = _curved(_main, 0.0, 0.28, Curves.easeOut);
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic)));

    _textFade = _curved(_main, 0.12, 0.40, Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.12, 0.42, curve: Curves.easeOutCubic)));

    _tagFade = _curved(_main, 0.38, 0.58, Curves.easeOut);

    _runwayProgress = _curved(_main, 0.05, 0.48, Curves.easeOut);

    // Plane rolls from left, lifts off, exits right
    _planeX = Tween<double>(begin: -0.65, end: 1.75)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.10, 0.88, curve: Curves.easeInOut)));
    _planeY = Tween<double>(begin: 0.0, end: -0.38)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.50, 0.88, curve: Curves.easeInCubic)));
    _planeAngle = Tween<double>(begin: 0, end: -math.pi / 5)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.46, 0.70, curve: Curves.easeInOut)));
    _planeScale = Tween<double>(begin: 1.0, end: 1.55)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.50, 0.88, curve: Curves.easeIn)));
    _planeFade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _main, curve: const Interval(0.80, 0.92, curve: Curves.easeIn)));

    _main.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  static Animation<double> _curved(AnimationController ctrl, double start, double end, Curve curve) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: ctrl, curve: Interval(start, end, curve: curve)),
      );

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
            // Subtle background clouds
            ..._clouds(size),

            // Center: logo image + brand name + tagline
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  FadeTransition(
                    opacity: _logoFade,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset('assets/images/app_logo.png', width: 96, height: 96),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Brand name
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: const Text(
                        'GenFly',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tagline
                  FadeTransition(
                    opacity: _tagFade,
                    child: const Text(
                      'Fly Smart. Fly Easy.',
                      style: TextStyle(color: Colors.white54, fontSize: 15, letterSpacing: 1.2),
                    ),
                  ),
                ],
              ),
            ),

            // Runway + airplane at lower third
            Positioned(
              bottom: size.height * 0.18,
              left: 0,
              right: 0,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Runway
                  AnimatedBuilder(
                    animation: _runwayProgress,
                    builder: (_, __) => CustomPaint(
                      size: Size(size.width, 60),
                      painter: _RunwayPainter(progress: _runwayProgress.value),
                    ),
                  ),
                  // Airplane
                  AnimatedBuilder(
                    animation: _main,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(
                        _planeX.value * size.width,
                        _planeY.value * size.height,
                      ),
                      child: Transform.rotate(
                        angle: _planeAngle.value,
                        child: Transform.scale(
                          scale: _planeScale.value,
                          child: Opacity(
                            opacity: _planeFade.value.clamp(0.0, 1.0),
                            child: const Icon(Icons.flight_rounded, color: Colors.white, size: 44),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pulsing loading dots at the very bottom
            Positioned(
              bottom: 52,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _dots,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final phase = ((_dots.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                    final opacity = 0.25 + 0.75 * math.sin(phase * math.pi);
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

  List<Widget> _clouds(Size size) {
    const data = [
      (0.08, 0.12, 70.0, 0.05),
      (0.68, 0.08, 90.0, 0.04),
      (0.82, 0.28, 55.0, 0.06),
      (0.12, 0.42, 65.0, 0.04),
      (0.55, 0.38, 50.0, 0.05),
      (0.35, 0.70, 80.0, 0.03),
    ];
    return data.map((d) {
      final (dx, dy, sz, alpha) = d;
      return Positioned(
        left: dx * size.width,
        top: dy * size.height,
        child: Icon(Icons.cloud_rounded, size: sz, color: Colors.white.withValues(alpha: alpha)),
      );
    }).toList();
  }
}

// Draws runway: two side lines + dashed centre line that expand left→right
class _RunwayPainter extends CustomPainter {
  final double progress;
  const _RunwayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final sidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const startX = 0.0;
    final endX = size.width * progress;
    final midY = size.height / 2;
    const laneH = 14.0;

    // Side rails
    canvas.drawLine(Offset(startX, midY - laneH), Offset(endX, midY - laneH), sidePaint);
    canvas.drawLine(Offset(startX, midY + laneH), Offset(endX, midY + laneH), sidePaint);

    // Dashed centre line
    const dashLen = 18.0;
    const gapLen = 10.0;
    double x = startX;
    while (x < endX) {
      final ex = math.min(x + dashLen, endX);
      canvas.drawLine(Offset(x, midY), Offset(ex, midY), dashPaint);
      x += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_RunwayPainter old) => old.progress != progress;
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
