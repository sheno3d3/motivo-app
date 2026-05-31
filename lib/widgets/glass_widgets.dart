// lib/widgets/glass_widgets.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ── Glass Card ───────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? background;
  final Color? borderColor;
  final double blurSigma;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key, required this.child,
    this.borderRadius = 22, this.padding,
    this.background, this.borderColor,
    this.blurSigma = 24, this.gradient, this.onTap,
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
            border: Border.all(color: borderColor ?? AppColors.border1),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
    if (onTap != null) return GestureDetector(onTap: onTap, child: card);
    return card;
  }
}

// ── Ambient Background ───────────────────────────────────
class AmbientBackground extends StatefulWidget {
  final Widget child;
  const AmbientBackground({super.key, required this.child});
  @override
  State<AmbientBackground> createState() => _AmbientBgState();
}

class _AmbientBgState extends State<AmbientBackground> with TickerProviderStateMixin {
  late AnimationController _c1, _c2, _c3;

  @override
  void initState() {
    super.initState();
    _c1 = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
    _c2 = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);
    _c3 = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
  }

  @override
  void dispose() { _c1.dispose(); _c2.dispose(); _c3.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(color: AppColors.navy),
      AnimatedBuilder(animation: _c1, builder: (_, __) => Positioned(
        top: -80 + _c1.value * -30, right: -60 + _c1.value * 20,
        child: _orb(320, AppColors.orange.withOpacity(.13)))),
      AnimatedBuilder(animation: _c2, builder: (_, __) => Positioned(
        top: 260 + _c2.value * 20, left: -90 + _c2.value * -16,
        child: _orb(260, AppColors.gold.withOpacity(.07)))),
      AnimatedBuilder(animation: _c3, builder: (_, __) => Positioned(
        bottom: 260 + _c3.value * 18, right: -40 + _c3.value * 18,
        child: _orb(220, AppColors.blue.withOpacity(.09)))),
      Positioned(bottom: 140, left: 10, child: _orb(180, AppColors.green.withOpacity(.06))),
      widget.child,
    ]);
  }

  Widget _orb(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 20)],
    ),
  );
}

// ── Step Ring ────────────────────────────────────────────
class StepRing extends StatefulWidget {
  final int steps, goal;
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
    Future.delayed(const Duration(milliseconds: 600), () { if (mounted) _ctrl.forward(); });
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(_fmt(widget.steps), style: AppTextStyles.display(size: 40)),
              const SizedBox(height: 5),
              Text('STEPS TODAY', style: AppTextStyles.label()),
              const SizedBox(height: 4),
              Text('${(pct * 100).round()}% of goal',
                style: AppTextStyles.body(size: 12, weight: FontWeight.w600, color: AppColors.orange)),
            ]),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) => n >= 1000
    ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}'
    : n.toString();
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 8;
    const sw = 8.0;
    canvas.drawCircle(c, r, Paint()
      ..color = Colors.white.withOpacity(.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw);
    if (progress <= 0) return;
    final rect = Rect.fromCircle(center: c, radius: r);
    final sweep = 2 * math.pi * progress;
    final grad = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + sweep,
      colors: const [AppColors.orange, AppColors.gold, Color(0xFFFFD166)],
    );
    canvas.drawArc(rect, -math.pi / 2, sweep, false,
      Paint()
        ..shader = grad.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round);
    canvas.drawArc(rect, -math.pi / 2, sweep, false,
      Paint()
        ..color = AppColors.orange.withOpacity(.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ── Coin Card ────────────────────────────────────────────
class CoinCard extends StatefulWidget {
  final int coins, todayCoins;
  final VoidCallback onTap;
  const CoinCard({super.key, required this.coins, required this.todayCoins, required this.onTap});
  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

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
              animation: _ctrl,
              builder: (_, child) => Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0x1CF5C842), Color(0x14FF6B35), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(.18 + _ctrl.value * .08)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                child: child,
              ),
              child: Row(children: [
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGrad,
                      boxShadow: [BoxShadow(
                        color: AppColors.gold.withOpacity(.35 + _ctrl.value * .3),
                        blurRadius: 20 + _ctrl.value * 20)],
                    ),
                    child: const Icon(Icons.hexagon_outlined, color: Color(0xFF1A0A00), size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_fmt(widget.coins),
                      style: AppTextStyles.display(size: 30, color: AppColors.gold)),
                    const SizedBox(height: 2),
                    Text('MOTIVO COINS', style: AppTextStyles.label(
                      color: AppColors.gold.withOpacity(.5))),
                  ],
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(.09),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.green.withOpacity(.18)),
                  ),
                  child: Text('+${widget.todayCoins} today',
                    style: AppTextStyles.body(size: 11, weight: FontWeight.w600,
                      color: AppColors.green)),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) => n >= 1000
    ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}'
    : n.toString();
}

// ── Mini Stat Box ────────────────────────────────────────
class MiniStatBox extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color iconColor;
  const MiniStatBox({super.key, required this.value, required this.label,
    required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(height: 5),
        Text(value, style: AppTextStyles.body(size: 13.5,
          weight: FontWeight.w700, color: AppColors.text1)),
        const SizedBox(height: 3),
        Text(label.toUpperCase(), style: AppTextStyles.label()),
      ]),
    );
  }
}

// ── Section Header ───────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

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
              child: Text(actionLabel!,
                style: AppTextStyles.body(size: 11, weight: FontWeight.w600,
                  color: AppColors.orange)),
            ),
        ],
      ),
    );
  }
}

// ── Glass Chip ───────────────────────────────────────────
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
      child: Text(label, style: AppTextStyles.body(
        size: 10.5, weight: FontWeight.w600, color: color)),
    );
  }
}

// ── Progress Bar ─────────────────────────────────────────
class MotivProgressBar extends StatelessWidget {
  final double progress;
  final List<Color> colors;
  final double height;
  const MotivProgressBar({super.key, required this.progress,
    required this.colors, this.height = 3.5});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeOutCubic,
        builder: (_, val, __) => Stack(children: [
          Container(height: height, color: Colors.white.withOpacity(.06)),
          FractionallySizedBox(
            widthFactor: val,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Mission Strip Card ───────────────────────────────────
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(mission.typeLabel,
            style: AppTextStyles.label(color: mission.typeColor)
              .copyWith(letterSpacing: .12)),
          const SizedBox(height: 8),
          Text(mission.title,
            style: AppTextStyles.display(size: 13.5, weight: FontWeight.w700),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 7),
          Text('⬡ ${mission.coinReward}${mission.extraReward != null ? ' + ${mission.extraReward}' : ''}',
            style: AppTextStyles.body(size: 10.5, weight: FontWeight.w600,
              color: AppColors.gold)),
          const SizedBox(height: 11),
          MotivProgressBar(
            progress: mission.progress,
            colors: [mission.typeColor, mission.typeColor.withOpacity(.7)],
            height: 2.5),
          const SizedBox(height: 6),
          Text(mission.progressLabel, style: AppTextStyles.label()),
        ]),
      ),
    );
  }
}

// ── Big Mission Card ─────────────────────────────────────
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              child: Stack(alignment: Alignment.center, children: [
                Icon(mission.icon, color: Colors.white.withOpacity(.85), size: 54),
                if (mission.status == MissionStatus.completed)
                  Positioned(top: 13, right: 13, child: _badge('Completed', AppColors.green))
                else if (mission.type == MissionType.golden)
                  Positioned(top: 13, right: 13, child: _badge('★ Golden', AppColors.gold))
                else
                  Positioned(top: 13, right: 13,
                    child: _badge(mission.timeLeft, mission.typeColor)),
              ]),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  mission.type == MissionType.golden
                    ? 'MONTHLY GOLDEN MISSION'
                    : mission.type == MissionType.daily
                    ? 'DAILY · RESETS MIDNIGHT'
                    : mission.typeLabel.toUpperCase(),
                  style: AppTextStyles.label(color: mission.typeColor)),
                const SizedBox(height: 7),
                Text(mission.title,
                  style: AppTextStyles.display(size: 20, weight: FontWeight.w700)),
                const SizedBox(height: 7),
                Text(mission.description, style: AppTextStyles.body()),
                const SizedBox(height: 14),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  GlassChip(label: '⬡ ${mission.coinReward} coins', color: AppColors.gold),
                  if (mission.timeLeft.isNotEmpty &&
                      mission.status != MissionStatus.completed)
                    GlassChip(label: mission.timeLeft, color: AppColors.blue),
                  if (mission.extraReward != null)
                    GlassChip(label: mission.extraReward!, color: AppColors.orange),
                ]),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Progress', style: AppTextStyles.label()),
                  Text(mission.progressLabel, style: AppTextStyles.label()),
                ]),
                const SizedBox(height: 8),
                MotivProgressBar(
                  progress: mission.progress,
                  colors: [mission.typeColor, mission.typeColor.withOpacity(.7)]),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: _buildButton()),
              ]),
            ),
          ]),
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

  Widget _buildButton() {
    if (mission.status == MissionStatus.completed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.green.withOpacity(.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.green.withOpacity(.2)),
        ),
        alignment: Alignment.center,
        child: Text('Claim Reward',
          style: AppTextStyles.button().copyWith(color: AppColors.green)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGrad,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: AppColors.orange.withOpacity(.28),
          blurRadius: 22, offset: const Offset(0, 5))],
      ),
      alignment: Alignment.center,
      child: Text(
        mission.progress > 0 ? 'Continue Mission' : 'Start Mission',
        style: AppTextStyles.button()),
    );
  }
}
