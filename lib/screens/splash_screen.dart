import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _twinkleCtrl;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    // Subtle twinkling stars animation around the emblem
    _twinkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Display for 2.6 seconds then seamlessly navigate
    _navTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _twinkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Matches native launch background perfectly
      body: Stack(
        children: [
          // ─── Subtle top-to-bottom background gradient ──────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFF8FAFC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ─── Landmark bottom illustration (RepaintBoundary for zero blur) ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: SizedBox(
                height: size.height * 0.36,
                child: CustomPaint(
                  painter: _LandscapePainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // ─── Center content: Logo, Title, Slogan, Tagline ──────────
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.08),

                // Emblem with twinkling stars (isolated in RepaintBoundary)
                SizedBox(
                  width: 220,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Twinkling stars (only this animates, repaints isolated)
                      RepaintBoundary(
                        child: AnimatedBuilder(
                          animation: _twinkleCtrl,
                          builder: (_, child) {
                            return CustomPaint(
                              size: const Size(220, 120),
                              painter: _StarsPainter(_twinkleCtrl.value),
                            );
                          },
                        ),
                      ),

                      // High-resolution Lingora emblem (100% sharp, no scaling transform)
                      Image.asset(
                        'assets/images/lingora_emblem.png',
                        width: 140,
                        height: 82,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Title – "Lingora" (Crisp native text rendering)
                const Text(
                  'Lingora',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle – "Speak a new world."
                const Text(
                  'Speak a new world.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 18),

                // Decorative brand divider with centered dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF4B3E), Color(0xFFFF7247)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tagline
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    'Learn languages. Explore cultures.\nConnect the world.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                      height: 1.5,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CustomPainter: twinkling 4-point stars ──────────────────────────────────
class _StarsPainter extends CustomPainter {
  final double t;

  const _StarsPainter(this.t);

  static const _stars = [
    _StarDef(-80, -35, 9, 0.0, 0),   // Coral top-left
    _StarDef(78, -32, 8, 0.35, 1),   // Indigo top-right
    _StarDef(-70, 30, 7, 0.7, 2),    // Gold bottom-left
    _StarDef(72, 32, 8, 0.15, 0),    // Coral bottom-right
    _StarDef(-95, 2, 6, 0.5, 1),     // Indigo far-left
    _StarDef(94, 4, 7, 0.85, 2),     // Gold far-right
  ];

  static const _colors = [
    Color(0xFFFF4B3E), // Coral
    Color(0xFF4F46E5), // Indigo
    Color(0xFFF59E0B), // Gold
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (final s in _stars) {
      final phase = (t + s.phase) % 1.0;
      final scale = 0.55 + 0.45 * math.sin(phase * math.pi);
      final opacity = (0.35 + 0.65 * scale).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = _colors[s.colorIndex].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      _drawStar(canvas, cx + s.dx, cy + s.dy, s.size * scale, paint);
    }
  }

  void _drawStar(Canvas canvas, double x, double y, double r, Paint paint) {
    final path = Path();
    const int points = 4;
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? r : r * 0.35;
      final px = x + radius * math.cos(angle);
      final py = y + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarsPainter old) => old.t != t;
}

class _StarDef {
  final double dx, dy, size, phase;
  final int colorIndex;
  const _StarDef(this.dx, this.dy, this.size, this.phase, this.colorIndex);
}

// ─── CustomPainter: landmark city-scape with waves ──────────────────────────
class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Wave layers (Warm Amber, Iris Indigo, Sapphire Navy) ─────────
    _drawWave(
      canvas,
      size,
      yBase: h * 0.68,
      waveH: h * 0.09,
      color: const Color(0xFF4F46E5).withValues(alpha: 0.18),
    );
    _drawWave(
      canvas,
      size,
      yBase: h * 0.72,
      waveH: h * 0.08,
      color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
      phaseShift: 0.6,
    );
    _drawWave(
      canvas,
      size,
      yBase: h * 0.76,
      waveH: h * 0.09,
      color: const Color(0xFF4F46E5).withValues(alpha: 0.55),
      phaseShift: 1.2,
    );
    // Solid bottom fill
    final fill = Paint()
      ..color = const Color(0xFF3730A3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, h * 0.82, w, h), fill);

    // ── Landmark silhouettes ──────────────────────────────────────────
    final silhouetteIndigo = Paint()
      ..color = const Color(0xFF4F46E5).withValues(alpha: 0.52)
      ..style = PaintingStyle.fill;
    final silhouetteCoral = Paint()
      ..color = const Color(0xFFFF7247).withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;

    final yGround = h * 0.76;

    // Eiffel Tower (left)
    _drawEiffel(canvas, w * 0.09, yGround, 0.55, silhouetteIndigo);
    // Pagoda (left-center)
    _drawPagoda(canvas, w * 0.25, yGround, 0.50, silhouetteCoral);
    // Taj Mahal (center)
    _drawTaj(canvas, w * 0.50, yGround, 0.65, silhouetteIndigo);
    // Big Ben (right-center)
    _drawBigBen(canvas, w * 0.75, yGround, 0.55, silhouetteCoral);
    // Colosseum arch (right)
    _drawColosseum(canvas, w * 0.91, yGround, 0.50, silhouetteIndigo);

    // Flying birds
    final birdPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    _drawBird(canvas, w * 0.60, h * 0.45, 6, birdPaint);
    _drawBird(canvas, w * 0.65, h * 0.42, 5, birdPaint);
    _drawBird(canvas, w * 0.70, h * 0.46, 4, birdPaint);
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double yBase,
    required double waveH,
    required Color color,
    double phaseShift = 0,
  }) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, yBase);
    for (double x = 0; x <= w; x++) {
      final y = yBase +
          math.sin((x / w * math.pi * 2) + phaseShift) * waveH -
          waveH * 0.5;
      path.lineTo(x, y);
    }
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawEiffel(
      Canvas canvas, double cx, double yBase, double scale, Paint p) {
    final bw = 34 * scale;
    final bh = 80 * scale;
    final path = Path()
      ..moveTo(cx - bw / 2, yBase)
      ..lineTo(cx - 2 * scale, yBase - bh * 0.7)
      ..lineTo(cx + 2 * scale, yBase - bh * 0.7)
      ..lineTo(cx + bw / 2, yBase)
      ..close();
    canvas.drawPath(path, p);
    canvas.drawRect(
        Rect.fromLTWH(cx - 1.5 * scale, yBase - bh, 3 * scale, bh * 0.3), p);
    canvas.drawRect(
        Rect.fromLTWH(cx - bw * 0.4, yBase - bh * 0.3, bw * 0.8, 3 * scale),
        p);
    canvas.drawRect(
        Rect.fromLTWH(cx - bw * 0.25, yBase - bh * 0.55, bw * 0.5, 2 * scale),
        p);
  }

  void _drawPagoda(
      Canvas canvas, double cx, double yBase, double scale, Paint p) {
    double y = yBase;
    for (int i = 0; i < 4; i++) {
      final tierW = (28 - i * 5) * scale;
      final tierH = 12 * scale;
      canvas.drawRect(Rect.fromLTWH(cx - tierW / 2, y - tierH, tierW, tierH), p);
      final eavePath = Path()
        ..moveTo(cx - tierW / 2 - 4 * scale, y - tierH)
        ..lineTo(cx, y - tierH - 5 * scale)
        ..lineTo(cx + tierW / 2 + 4 * scale, y - tierH)
        ..close();
      canvas.drawPath(eavePath, p);
      y -= tierH + 2 * scale;
    }
    canvas.drawRect(Rect.fromLTWH(cx - scale, y - 8 * scale, 2 * scale, 8 * scale), p);
  }

  void _drawTaj(Canvas canvas, double cx, double yBase, double scale, Paint p) {
    final domeRect = Rect.fromCenter(
        center: Offset(cx, yBase - 52 * scale), width: 40 * scale, height: 50 * scale);
    canvas.drawOval(domeRect, p);
    canvas.drawRect(Rect.fromLTWH(cx - 28 * scale, yBase - 28 * scale, 56 * scale, 28 * scale), p);
    for (final dx in [-22.0, 22.0]) {
      final miniRect = Rect.fromCenter(
          center: Offset(cx + dx * scale, yBase - 30 * scale),
          width: 14 * scale,
          height: 18 * scale);
      canvas.drawOval(miniRect, p);
    }
    for (final dx in [-34.0, 34.0]) {
      canvas.drawRect(Rect.fromLTWH(cx + dx * scale - 2.5 * scale, yBase - 52 * scale, 5 * scale, 52 * scale), p);
      final miniDome = Rect.fromCenter(
          center: Offset(cx + dx * scale, yBase - 54 * scale),
          width: 8 * scale,
          height: 10 * scale);
      canvas.drawOval(miniDome, p);
    }
    canvas.drawRect(Rect.fromLTWH(cx - scale, yBase - 82 * scale, 2 * scale, 10 * scale), p);
  }

  void _drawBigBen(
      Canvas canvas, double cx, double yBase, double scale, Paint p) {
    final tw = 18 * scale;
    final th = 70 * scale;
    canvas.drawRect(Rect.fromLTWH(cx - tw / 2, yBase - th, tw, th), p);
    final clockPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, yBase - th + 12 * scale), 6 * scale, clockPaint);
    final topPath = Path()
      ..moveTo(cx - tw / 2, yBase - th)
      ..lineTo(cx, yBase - th - 16 * scale)
      ..lineTo(cx + tw / 2, yBase - th)
      ..close();
    canvas.drawPath(topPath, p);
  }

  void _drawColosseum(
      Canvas canvas, double cx, double yBase, double scale, Paint p) {
    final arcRect = Rect.fromLTWH(cx - 30 * scale, yBase - 40 * scale, 60 * scale, 40 * scale);
    final outerPath = Path()..addArc(arcRect, math.pi, math.pi);
    outerPath.close();
    canvas.drawPath(outerPath, p);
    final innerPaint = Paint()
      ..color = const Color(0xFF4F46E5).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 3; i++) {
      final ax = cx - 18 * scale + i * 18 * scale;
      final archRect = Rect.fromLTWH(ax - 4 * scale, yBase - 28 * scale, 8 * scale, 16 * scale);
      final archPath = Path()..addArc(archRect, math.pi, math.pi);
      archPath.close();
      canvas.drawPath(archPath, innerPaint);
    }
  }

  void _drawBird(Canvas canvas, double x, double y, double size, Paint p) {
    final path = Path()
      ..moveTo(x - size, y)
      ..quadraticBezierTo(x - size * 0.4, y - size * 0.6, x, y)
      ..quadraticBezierTo(x + size * 0.4, y - size * 0.6, x + size, y);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_LandscapePainter old) => false;
}
