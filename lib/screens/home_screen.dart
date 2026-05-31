// lib/screens/home_screen.dart
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/glass_widgets.dart';
import 'missions_screen.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const user = SampleData.user;
    const stats = SampleData.today;
    final missions = SampleData.dailyMissions + SampleData.weeklyMissions;
    final offers = SampleData.rewards.take(5).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero section ──────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                // Greeting row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SUNDAY, 1 JUNE 2025',
                          style: AppTextStyles.label()),
                        const SizedBox(height: 6),
                        Text(user.name,
                          style: AppTextStyles.display(size: 24, weight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    _BellButton(),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -.15, end: 0),

                const SizedBox(height: 24),

                // Step ring
                StepRing(steps: stats.steps, goal: stats.stepGoal)
                  .animate(delay: 200.ms).fadeIn(duration: 600.ms),

                const SizedBox(height: 20),

                // Mini stats
                Row(
                  children: [
                    Expanded(child: MiniStatBox(
                      value: '${stats.km}', label: 'km',
                      icon: Icons.straighten, iconColor: AppColors.orange)),
                    const SizedBox(width: 7),
                    Expanded(child: MiniStatBox(
                      value: '${stats.calories}', label: 'kcal',
                      icon: Icons.favorite_border, iconColor: AppColors.rose)),
                    const SizedBox(width: 7),
                    Expanded(child: MiniStatBox(
                      value: '${stats.activeMinutes}', label: 'min',
                      icon: Icons.schedule_outlined, iconColor: AppColors.blue)),
                    const SizedBox(width: 7),
                    Expanded(child: MiniStatBox(
                      value: '${user.streakDays}🔥', label: 'streak',
                      icon: Icons.local_fire_department_outlined, iconColor: AppColors.gold)),
                  ],
                ).animate(delay: 300.ms).fadeIn(duration: 500.ms),
              ],
            ),
          ),

          // ── Coin card ─────────────────────────────────
          CoinCard(
            coins: user.totalCoins,
            todayCoins: stats.coinsEarnedToday,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RewardsScreen())),
          ).animate(delay: 400.ms).fadeIn(duration: 500.ms),

          // ── Active Missions ───────────────────────────
          SectionHeader(
            title: 'Active Missions',
            actionLabel: 'View all',
            onAction: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MissionsScreen())),
          ).animate(delay: 450.ms).fadeIn(),

          SizedBox(
            height: 178,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: missions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 11),
              itemBuilder: (ctx, i) => MissionStripCard(
                mission: missions[i],
                onTap: () => _showMissionModal(ctx, missions[i]),
              ).animate(delay: (500 + i * 80).ms).fadeIn().slideX(begin: .1, end: 0),
            ),
          ),

          // ── Hot Offers ────────────────────────────────
          SectionHeader(
            title: 'Hot Offers 🔥',
            actionLabel: 'See all',
            onAction: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RewardsScreen())),
          ).animate(delay: 550.ms).fadeIn(),

          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: offers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (ctx, i) => _OfferCard(
                reward: offers[i],
                onTap: () => _showRewardModal(ctx, offers[i]),
              ).animate(delay: (600 + i * 70).ms).fadeIn(),
            ),
          ),

          // ── Affiliates ────────────────────────────────
          const SectionHeader(title: 'Earn via Affiliates'),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              itemCount: SampleData.affiliates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final a = SampleData.affiliates[i];
                return _AffiliateCard(
                  name: a['name'] as String,
                  coins: a['coins'] as String,
                  color: a['color'] as Color,
                ).animate(delay: (700 + i * 60).ms).fadeIn();
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showMissionModal(BuildContext context, Mission mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MissionModal(mission: mission),
    );
  }

  void _showRewardModal(BuildContext context, Reward reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RewardModal(reward: reward, userCoins: SampleData.user.availableCoins),
    );
  }
}

// Bell button
class _BellButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 13,
      padding: const EdgeInsets.all(10),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('3 new missions unlocked'))),
      child: Stack(
        children: [
          const Icon(Icons.notifications_outlined, color: AppColors.text2, size: 20),
          Positioned(
            top: 0, right: 0,
            child: Container(
              width: 7, height: 7,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Offer card
class _OfferCard extends StatelessWidget {
  final Reward reward;
  final VoidCallback onTap;
  const _OfferCard({required this.reward, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 134,
          decoration: BoxDecoration(
            color: AppColors.glass1,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [reward.heroBgStart, reward.heroBgEnd],
                  ),
                ),
                child: Center(
                  child: Icon(reward.icon, color: Colors.white.withOpacity(.8), size: 34),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reward.category.name.toUpperCase(),
                      style: AppTextStyles.label()),
                    const SizedBox(height: 3),
                    Text(reward.title,
                      style: AppTextStyles.body(size: 12, weight: FontWeight.w600, color: AppColors.text1),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.orange.withOpacity(.22)),
                      ),
                      child: Text('⬡ ${reward.coinCost}',
                        style: AppTextStyles.body(size: 10, weight: FontWeight.w700, color: AppColors.orange)),
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
}

// Affiliate card
class _AffiliateCard extends StatelessWidget {
  final String name;
  final String coins;
  final Color color;
  const _AffiliateCard({required this.name, required this.coins, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: SizedBox(
        width: 92,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_circle_outline, color: color, size: 18),
            ),
            const SizedBox(height: 7),
            Text(name,
              style: AppTextStyles.body(size: 10, weight: FontWeight.w700, color: AppColors.text1),
              textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(coins,
              style: AppTextStyles.body(size: 9.5, weight: FontWeight.w600, color: AppColors.orange)),
          ],
        ),
      ),
    );
  }
}

// ─── Mission Modal ───────────────────────────────────────
class MissionModal extends StatelessWidget {
  final Mission mission;
  const MissionModal({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xF707101C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.border1),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 44),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 3.5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.13),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 22),
            // Icon
            Center(
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: mission.typeColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: mission.typeColor.withOpacity(.22)),
                ),
                child: Icon(mission.icon, color: Colors.white.withOpacity(.9), size: 36),
              ).animate().scale(begin: const Offset(0, 0), end: const Offset(1, 1),
                curve: Curves.elasticOut, duration: 500.ms),
            ),
            const SizedBox(height: 16),
            Text(mission.title,
              style: AppTextStyles.display(size: 22, weight: FontWeight.w700)),
            const SizedBox(height: 7),
            Text(mission.description,
              style: AppTextStyles.body()),
            const SizedBox(height: 16),
            Wrap(spacing: 6, runSpacing: 6, children: [
              GlassChip(label: '⬡ ${mission.coinReward} coins', color: AppColors.gold),
              if (mission.extraReward != null)
                GlassChip(label: mission.extraReward!, color: AppColors.orange),
              if (mission.timeLeft.isNotEmpty)
                GlassChip(label: mission.timeLeft, color: AppColors.blue),
            ]),
            const SizedBox(height: 20),
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
              height: 5,
            ),
            const SizedBox(height: 20),
            // CTA
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGrad,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: AppColors.orange.withOpacity(.28), blurRadius: 22, offset: const Offset(0, 5)),
                  ],
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mission activated!')));
                  },
                  child: Text(
                    mission.status == MissionStatus.completed ? 'Claim Reward' :
                    mission.progress > 0 ? 'Continue Mission' : 'Start Mission',
                    style: AppTextStyles.button(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Maybe later',
                  style: AppTextStyles.body(size: 12.5, weight: FontWeight.w500, color: AppColors.text2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reward Modal ─────────────────────────────────────────
class RewardModal extends StatelessWidget {
  final Reward reward;
  final int userCoins;
  const RewardModal({super.key, required this.reward, required this.userCoins});

  @override
  Widget build(BuildContext context) {
    final canAfford = userCoins >= reward.coinCost;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xF707101C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.border1),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 3.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.13),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [reward.heroBgStart, reward.heroBgEnd],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(reward.icon, color: Colors.white.withOpacity(.9), size: 36),
            ).animate().scale(begin: const Offset(0, 0), end: const Offset(1, 1),
              curve: Curves.elasticOut, duration: 500.ms),
          ),
          const SizedBox(height: 16),
          Text(reward.title, style: AppTextStyles.display(size: 22, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(reward.brand.toUpperCase(), style: AppTextStyles.label()),
          const SizedBox(height: 8),
          Text(reward.description, style: AppTextStyles.body()),
          const SizedBox(height: 18),
          // Cost / Balance row
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.orange.withOpacity(.10)),
            ),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('COST', style: AppTextStyles.label()),
                  const SizedBox(height: 4),
                  Text('${reward.coinCost} ⬡',
                    style: AppTextStyles.display(size: 26, weight: FontWeight.w900, color: AppColors.orange)),
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('YOUR BALANCE', style: AppTextStyles.label()),
                  const SizedBox(height: 4),
                  Text('$userCoins ⬡',
                    style: AppTextStyles.display(size: 26, weight: FontWeight.w900, color: AppColors.green)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: canAfford ? () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redeemed — check your wallet!')));
              } : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: canAfford ? AppColors.orangeGrad : null,
                  color: canAfford ? null : AppColors.glass2,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: canAfford ? [
                    BoxShadow(color: AppColors.orange.withOpacity(.28), blurRadius: 22, offset: const Offset(0, 5)),
                  ] : null,
                ),
                alignment: Alignment.center,
                child: Text('Redeem Now',
                  style: AppTextStyles.button().copyWith(
                    color: canAfford ? Colors.white : AppColors.text3)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                style: AppTextStyles.body(size: 12.5, weight: FontWeight.w500, color: AppColors.text2)),
            ),
          ),
        ],
      ),
    );
  }
}
