// lib/widgets/glass_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../models/models.dart';

// ─── Glass Card ─────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? background;
  final Color? borderColor;
  final double blurSigma;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 22,
    this.padding,
    this.background,
    this.borderColor,
    this.blurSigma = 24,
    this.gradient,
    this.onTap,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color: background ?? AppColors.glass1,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.border1,
              width: 1,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

// ─── Ambient Background ─────────────────────────────────
class AmbientBackground extends StatefulWidget {
  final Widget child;
  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _ctrl1, _ctrl2, _ctrl3;
  late Animation<Offset> _anim1, _anim2, _anim3;

  @override
  void initState() {
    super.initState();
    _ctrl1 = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
    _ctrl2 = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);
    _ctrl3 = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _anim1 = Tween(begin: Offset.zero, end: const Offset(22, -32)).animate(
        CurvedAnimation(parent: _ctrl1, curve: Curves.easeInOut));
    _anim2 = Tween(begin: Offset.zero, end: const Offset(-16, 22)).animate(
        CurvedAnimation(parent: _ctrl2, curve: Curves.easeInOut));
    _anim3 = Tween(begin: Offset.zero, end: const Offset(18, -18)).animate(
        CurvedAnimation(parent: _ctrl3, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl1.dispose(); _ctrl2.dispose(); _ctrl3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep navy base
        Container(color: AppColors.navy),
        // Orb 1 — orange top right
        AnimatedBuilder(animation: _anim1, builder: (_, __) => Positioned(
          top: -80 + _anim1.value.dy, right: -60 + _anim1.value.dx,
          child: _buildOrb(320, AppColors.orange.withOpacity(.13)),
        )),
        // Orb 2 — gold mid left
        AnimatedBuilder(animation: _anim2, builder: (_, __) => Positioned(
          top: 260 + _anim2.value.dy, left: -90 + _anim2.value.dx,
          child: _buildOrb(260, AppColors.gold.withOpacity(.07)),
        )),
        // Orb 3 — blue lower right
        AnimatedBuilder(animation: _anim3, builder: (_, __) => Positioned(
          bottom: 260 + _anim3.value.dy, right: -40 + _anim3.value.dx,
          child: _buildOrb(220, AppColors.blue.withOpacity(.09)),
        )),
        // Orb 4 — green bottom left
        Positioned(
          bottom: 140, left: 10,
          child: _buildOrb(180, AppColors.green.withOpacity(.06)),
        ),
        // Content
        widget.child,
      ],
    );
  }

  Widget _buildOrb(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 20)],
    ),
  );
}

// ─── Step Ring ───────────────────────────────────────────
class StepRing extends StatefulWidget {
  final int steps;
  final int goal;
  const StepRing({super.key, required this.steps, required this.goal});

  @override
  State<StepRing> createState() => _StepRingState();
}

class _StepRingState extends State<StepRing> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 600), () => _ctrl.forward());
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pct = widget.steps / widget.goal;
    return SizedBox(
      width: 192, height: 192,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => CustomPaint(
          painter: _RingPainter(progress: _anim.value * pct),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatNumber(widget.steps),
                  style: AppTextStyles.display(size: 40),
                ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: .2, end: 0),
                const SizedBox(height: 5),
                Text('STEPS TODAY',
                  style: AppTextStyles.label()),
                const SizedBox(height: 4),
                Text('${(pct * 100).round()}% of goal',
                  style: AppTextStyles.body(size: 12, weight: FontWeight.w600, color: AppColors.orange)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n ~/ 1000)},${(n % 1000).toString().padLeft(3, '0')}';
    }
    return n.toString();
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final strokeWidth = 8.0;

    // Track
    canvas.drawCircle(center, radius, Paint()
      ..color = Colors.white.withOpacity(.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth);

    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -1.5708, // -90 degrees
      endAngle: -1.5708 + (2 * 3.14159 * progress),
      colors: const [AppColors.orange, AppColors.gold, Color(0xFFFFD166)],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -1.5708, 2 * 3.14159 * progress, false, paint);

    // Glow effect
    final glowPaint = Paint()
      ..color = AppColors.orange.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(rect, -1.5708, 2 * 3.14159 * progress, false, glowPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ─── Coin Card ───────────────────────────────────────────
class CoinCard extends StatefulWidget {
  final int coins;
  final int todayCoins;
  final VoidCallback onTap;

  const CoinCard({
    super.key,
    required this.coins,
    required this.todayCoins,
    required this.onTap,
  });

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
    _glowAnim = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _glowCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 14, 24, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, child) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withOpacity(.11),
                      AppColors.orange.withOpacity(.08),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(.18 + _glowAnim.value * .08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(.05 + _glowAnim.value * .05),
                      blurRadius: 24, spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                child: child,
              ),
              child: Row(
                children: [
                  // Gold orb
                  AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (_, __) => Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGrad,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(.35 + _glowAnim.value * .3),
                            blurRadius: 20 + _glowAnim.value * 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.hexagon_outlined, color: Color(0xFF1A0A00), size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fmt(widget.coins),
                          style: AppTextStyles.display(size: 30, color: AppColors.gold),
                        ),
                        const SizedBox(height: 2),
                        Text('MOTIVO COINS',
                          style: AppTextStyles.label(color: AppColors.gold.withOpacity(.5))),
                      ],
                    ),
                  ),
                  // Today badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(.09),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.green.withOpacity(.18)),
                    ),
                    child: Text(
                      '+${widget.todayCoins} today',
                      style: AppTextStyles.body(
                        size: 11, weight: FontWeight.w600, color: AppColors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) return '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}';
    return n.toString();
  }
}

// ─── Mini Stat Box ───────────────────────────────────────
class MiniStatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const MiniStatBox({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(height: 5),
          Text(value, style: AppTextStyles.body(size: 13.5, weight: FontWeight.w700, color: AppColors.text1)),
          const SizedBox(height: 3),
          Text(label.toUpperCase(), style: AppTextStyles.label()),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(title, style: AppTextStyles.display(size: 18, weight: FontWeight.w700)),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.body(size: 11, weight: FontWeight.w600, color: AppColors.orange),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Glass Chip ──────────────────────────────────────────
class GlassChip extends StatelessWidget {
  final String label;
  final Color color;

  const GlassChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withOpacity(.18)),
      ),
      child: Text(label,
        style: AppTextStyles.body(size: 10.5, weight: FontWeight.w600, color: color)),
    );
  }
}

// ─── Smooth Progress Bar ─────────────────────────────────
class MotivProgressBar extends StatelessWidget {
  final double progress;
  final List<Color> colors;
  final double height;

  const MotivProgressBar({
    super.key,
    required this.progress,
    required this.colors,
    this.height = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeOutCubic,
        builder: (_, val, __) => Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.06)),
            ),
            FractionallySizedBox(
              widthFactor: val.clamp(0, 1),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mission Strip Card ──────────────────────────────────
class MissionStripCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;

  const MissionStripCard({super.key, required this.mission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: mission.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mission.typeColor.withOpacity(.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shine orb
            Stack(children: [
              Positioned(
                top: -8, right: -8,
                child: Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: mission.typeColor.withOpacity(.35), blurRadius: 30)],
                  ),
                ),
              ),
            ]),
            // Type tag
            Row(children: [
              Text(mission.typeLabel,
                style: AppTextStyles.label(color: mission.typeColor).copyWith(letterSpacing: .12)),
            ]),
            const SizedBox(height: 8),
            // Title
            Text(mission.title,
              style: AppTextStyles.display(size: 13.5, weight: FontWeight.w700),
              maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 7),
            // Reward
            Text(
              '⬡ ${mission.coinReward} coins${mission.extraReward != null ? ' + ${mission.extraReward}' : ''}',
              style: AppTextStyles.body(size: 10.5, weight: FontWeight.w600, color: AppColors.gold),
            ),
            const SizedBox(height: 11),
            // Progress
            MotivProgressBar(
              progress: mission.progress,
              colors: [mission.typeColor, mission.typeColor.withOpacity(.7)],
              height: 2.5,
            ),
            const SizedBox(height: 6),
            Text(mission.progressLabel,
              style: AppTextStyles.label()),
          ],
        ),
      ),
    );
  }
}

// ─── Big Mission Card ────────────────────────────────────
class BigMissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;

  const BigMissionCard({super.key, required this.mission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 13),
        decoration: BoxDecoration(
          color: AppColors.glass1,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero
              Container(
                height: 138,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [
                      mission.typeColor.withOpacity(.09),
                      mission.typeColor.withOpacity(.04),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(mission.icon, color: Colors.white.withOpacity(.85), size: 54),
                    // Badge
                    if (mission.status == MissionStatus.completed)
                      Positioned(
                        top: 13, right: 13,
                        child: _badge('Completed', AppColors.green),
                      )
                    else if (mission.type == MissionType.golden)
                      Positioned(
                        top: 13, right: 13,
                        child: _badge('★ Golden', AppColors.gold),
                      )
                    else
                      Positioned(
                        top: 13, right: 13,
                        child: _badge(mission.timeLeft, mission.typeColor),
                      ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Eyebrow
                    Text(
                      mission.type == MissionType.golden
                          ? 'MONTHLY GOLDEN MISSION'
                          : mission.type == MissionType.daily
                          ? 'DAILY · RESETS MIDNIGHT'
                          : mission.typeLabel.toUpperCase(),
                      style: AppTextStyles.label(color: mission.typeColor),
                    ),
                    const SizedBox(height: 7),
                    Text(mission.title,
                      style: AppTextStyles.display(size: 20, weight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    Text(mission.description,
                      style: AppTextStyles.body(),
                    ),
                    const SizedBox(height: 14),
                    // Chips
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      GlassChip(label: '⬡ ${mission.coinReward} coins', color: AppColors.gold),
                      if (mission.timeLeft.isNotEmpty && mission.status != MissionStatus.completed)
                        GlassChip(label: mission.timeLeft, color: AppColors.blue),
                      if (mission.extraReward != null)
                        GlassChip(label: mission.extraReward!, color: AppColors.orange),
                    ]),
                    const SizedBox(height: 16),
                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress', style: AppTextStyles.label()),
                        Text(mission.progressLabel, style: AppTextStyles.label()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MotivProgressBar(
                      progress: mission.progress,
                      colors: [mission.typeColor, mission.typeColor.withOpacity(.7)],
                    ),
                    const SizedBox(height: 16),
                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: _buildButton(mission),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(.16),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(.32)),
    ),
    child: Text(text, style: AppTextStyles.label(color: color)),
  );

  Widget _buildButton(Mission mission) {
    if (mission.status == MissionStatus.completed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.green.withOpacity(.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.green.withOpacity(.2)),
        ),
        alignment: Alignment.center,
        child: Text('Claim Reward', style: AppTextStyles.button().copyWith(color: AppColors.green)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGrad,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.orange.withOpacity(.28), blurRadius: 22, offset: const Offset(0, 5)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        mission.progress > 0 ? 'Continue Mission' : 'Start Mission',
        style: AppTextStyles.button(),
      ),
    );
  }
}

// ─── Coin Burst Overlay ──────────────────────────────────
class CoinBurstOverlay extends StatefulWidget {
  final Widget child;
  const CoinBurstOverlay({super.key, required this.child});

  static CoinBurstOverlayState? of(BuildContext context) =>
    context.findAncestorStateOfType<CoinBurstOverlayState>();

  @override
  State<CoinBurstOverlay> createState() => CoinBurstOverlayState();
}

class CoinBurstOverlayState extends State<CoinBurstOverlay> {
  final List<_CoinParticle> _particles = [];
  int _nextId = 0;

  void trigger(Offset position) {
    setState(() {
      for (int i = 0; i < 18; i++) {
        final angle = (i / 18) * 2 * 3.14159;
        final distance = 50.0 + (i % 3) * 35;
        _particles.add(_CoinParticle(
          id: _nextId++,
          position: position,
          velocity: Offset(
            distance * 1.2 * (angle < 3.14159 ? 1 : -1) * (0.5 + (i % 4) * 0.3),
            -distance - (i % 5) * 20,
          ),
          color: [AppColors.gold, AppColors.orange, Colors.white, AppColors.green][i % 4],
          symbol: ['⬡', '✦', '◆', '✧', '⊙'][i % 5],
        ));
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _particles.removeWhere((p) => p.id < _nextId - 18));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ..._particles.map((p) => _AnimatedCoin(particle: p)),
      ],
    );
  }
}

class _CoinParticle {
  final int id;
  final Offset position;
  final Offset velocity;
  final Color color;
  final String symbol;
  _CoinParticle({required this.id, required this.position, required this.velocity, required this.color, required this.symbol});
}

class _AnimatedCoin extends StatefulWidget {
  final _CoinParticle particle;
  const _AnimatedCoin({required this.particle});

  @override
  State<_AnimatedCoin> createState() => _AnimatedCoinState();
}

class _AnimatedCoinState extends State<_AnimatedCoin> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _pos;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
    _pos = Tween(begin: widget.particle.position,
        end: widget.particle.position + widget.particle.velocity)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fade = Tween(begin: 1.0, end: 0.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(.4, 1, curve: Curves.easeIn)));
    _scale = Tween(begin: 0.0, end: .4)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Positioned(
        left: _pos.value.dx - 8,
        top: _pos.value.dy - 8,
        child: Opacity(
          opacity: _fade.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Text(
              widget.particle.symbol,
              style: TextStyle(fontSize: 16, color: widget.particle.color),
            ),
          ),
        ),
      ),
    );
  }
}
