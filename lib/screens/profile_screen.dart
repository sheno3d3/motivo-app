// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/glass_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const user = SampleData.user;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.orangeGrad,
                boxShadow: [
                  BoxShadow(color: AppColors.orange.withOpacity(.25), blurRadius: 36),
                  BoxShadow(color: AppColors.orange.withOpacity(.28), spreadRadius: 3),
                ],
                border: Border.all(color: Colors.white.withOpacity(.14), width: 2),
              ),
              child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 10),
            Text(user.name,
              style: AppTextStyles.display(size: 23, weight: FontWeight.w700),
              textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${user.handle} · Member since Jan 2024',
              style: AppTextStyles.body(size: 11.5, color: AppColors.text3)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withOpacity(.18)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 13),
                const SizedBox(width: 6),
                Text('Level ${user.level} — ${user.levelTitle}',
                  style: AppTextStyles.body(size: 11, weight: FontWeight.w600,
                    color: AppColors.gold)),
              ]),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _StreakCard(user: user),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 7, crossAxisSpacing: 7,
            childAspectRatio: 1.15,
            children: [
              _StatBox(value: '2.4M', label: 'Steps'),
              _StatBox(value: '4,560', label: 'Coins'),
              _StatBox(value: '38', label: 'Missions'),
              _StatBox(value: '1,847', label: 'km'),
              _StatBox(value: '12', label: 'Redeemed'),
              _StatBox(value: '7', label: 'Referrals'),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            _MenuItem(icon: Icons.group_outlined, label: 'Invite Friends',
              badge: '+300 each', color: AppColors.gold,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AHMED-X9K2 copied!')))),
            const SizedBox(height: 7),
            _MenuItem(icon: Icons.bar_chart_rounded, label: 'Weekly Progress',
              color: AppColors.orange, onTap: () {}),
            const SizedBox(height: 7),
            _MenuItem(icon: Icons.emoji_events_outlined, label: 'Achievements',
              badge: '3 new', color: AppColors.green,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('3 new achievements!')))),
            const SizedBox(height: 7),
            _MenuItem(icon: Icons.link_rounded, label: 'Connected Apps',
              color: AppColors.blue,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connected: Apple Health, Fitbit')))),
            const SizedBox(height: 7),
            _MenuItem(icon: Icons.settings_outlined, label: 'Settings',
              color: AppColors.text3, onTap: () {}),
          ]),
        ),

        const SizedBox(height: 24),
      ]),
    );
  }
}

class _StreakCard extends StatefulWidget {
  final UserProfile user;
  const _StreakCard({required this.user});
  @override
  State<_StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<_StreakCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.orange.withOpacity(.14), AppColors.orangeDark.withOpacity(.08)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withOpacity(.2)),
      ),
      child: Row(children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.scale(
            scale: 1.0 + _ctrl.value * 0.08,
            child: child),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(.25),
              borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.local_fire_department_rounded,
              color: AppColors.orange, size: 24),
          ),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${widget.user.streakDays}',
            style: AppTextStyles.display(size: 32, weight: FontWeight.w900)),
          Text('Day Streak — Keep going',
            style: AppTextStyles.body(size: 11.5, weight: FontWeight.w500,
              color: AppColors.text2)),
        ]),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('BEST', style: AppTextStyles.label()),
          const SizedBox(height: 4),
          Text('${widget.user.bestStreak} days',
            style: AppTextStyles.display(size: 21, weight: FontWeight.w700)),
        ]),
      ]),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 15, padding: const EdgeInsets.all(8),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: AppTextStyles.display(size: 18, weight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: AppTextStyles.label()),
      ]),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label,
    required this.color, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 15,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.body(
            size: 13.5, weight: FontWeight.w500, color: AppColors.text1))),
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.orange, borderRadius: BorderRadius.circular(7)),
              child: Text(badge!, style: AppTextStyles.body(
                size: 9, weight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(width: 8),
          ],
          Text('›', style: AppTextStyles.body(size: 14, color: AppColors.text3)),
        ]),
      ),
    );
  }
}
