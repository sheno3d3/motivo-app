// lib/screens/rewards_screen.dart
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/glass_widgets.dart';
import 'home_screen.dart' show RewardModal;

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const user = SampleData.user;
    final rewards = SampleData.rewards;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Wallet hero ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YOUR WALLET', style: AppTextStyles.label()),
                const SizedBox(height: 12),
                _WalletCard(user: user),
              ],
            ).animate().fadeIn(duration: 500.ms),
          ),

          const SizedBox(height: 14),

          // ── Referral card ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _ReferralCard(code: user.referralCode),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: .06, end: 0),

          // ── Offers grid ──
          SectionHeader(
            title: 'Redeem Offers',
            actionLabel: 'Filter',
            onAction: () {},
          ).animate(delay: 300.ms).fadeIn(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 9,
                crossAxisSpacing: 9,
                childAspectRatio: .85,
              ),
              itemCount: rewards.length,
              itemBuilder: (ctx, i) => _RewardGridCard(
                reward: rewards[i],
                onTap: () => showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => RewardModal(reward: rewards[i], userCoins: user.availableCoins),
                ),
              ).animate(delay: (350 + i * 70).ms).fadeIn().scale(
                begin: const Offset(.95, .95), end: const Offset(1, 1)),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Wallet Card ─────────────────────────────────────────
class _WalletCard extends StatelessWidget {
  final UserProfile user;
  const _WalletCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x26FF6B35), Color(0x18D94F1E), Color(0x12F5C842),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.orange.withOpacity(.2)),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glow
              Stack(children: [
                Positioned(
                  top: -80, right: -80,
                  child: Container(
                    width: 240, height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(
                        color: AppColors.orange.withOpacity(.16), blurRadius: 90, spreadRadius: 20)],
                    ),
                  ),
                ),
              ]),
              Text('TOTAL BALANCE', style: AppTextStyles.label(color: AppColors.text1.withOpacity(.38))),
              const SizedBox(height: 5),
              Text(
                _fmt(user.totalCoins),
                style: AppTextStyles.display(size: 54, weight: FontWeight.w900),
              ),
              const SizedBox(height: 3),
              Text(
                'Motivo Coins · Level ${user.level} ${user.levelTitle}',
                style: AppTextStyles.body(size: 11.5, color: AppColors.text1.withOpacity(.36)),
              ),
              const SizedBox(height: 18),
              Row(children: [
                _WBPill(label: 'Available', value: _fmt(user.availableCoins)),
                const SizedBox(width: 8),
                _WBPill(label: 'Pending', value: _fmt(user.pendingCoins)),
                const SizedBox(width: 8),
                _WBPill(label: 'Used', value: _fmt(user.usedCoins)),
              ]),
              const SizedBox(height: 16),
              // Redeem button
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGrad,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: AppColors.orange.withOpacity(.32), blurRadius: 26, offset: const Offset(0, 6)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text('Redeem Coins', style: AppTextStyles.button()),
                ),
              ),
            ],
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

class _WBPill extends StatelessWidget {
  final String label, value;
  const _WBPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.055),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: AppTextStyles.label()),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.display(size: 17, weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ─── Referral Card ───────────────────────────────────────
class _ReferralCard extends StatelessWidget {
  final String code;
  const _ReferralCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.blue.withOpacity(.12), AppColors.cyan.withOpacity(.06)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.blue.withOpacity(.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invite Friends, Earn Together',
            style: AppTextStyles.display(size: 15, weight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text('Share your code. 300 coins per friend who joins and walks.',
            style: AppTextStyles.body(size: 12)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.045),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white.withOpacity(.09)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(code,
                    style: AppTextStyles.display(size: 15, weight: FontWeight.w700, color: AppColors.gold)
                      .copyWith(letterSpacing: .07)),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$code copied to clipboard',
                          style: AppTextStyles.body(size: 12, color: AppColors.text1)),
                        backgroundColor: AppColors.navy2,
                      ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text('Copy', style: AppTextStyles.button(size: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reward Grid Card ────────────────────────────────────
class _RewardGridCard extends StatelessWidget {
  final Reward reward;
  final VoidCallback onTap;
  const _RewardGridCard({required this.reward, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glass1,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [reward.heroBgStart, reward.heroBgEnd],
                    ),
                  ),
                  child: Center(
                    child: Icon(reward.icon, color: Colors.white.withOpacity(.85), size: 38),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reward.brand.toUpperCase(), style: AppTextStyles.label()),
                    const SizedBox(height: 3),
                    Text(reward.title,
                      style: AppTextStyles.body(size: 12, weight: FontWeight.w600, color: AppColors.text1),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('⬡ ${reward.coinCost}',
                          style: AppTextStyles.body(size: 11, weight: FontWeight.w700, color: AppColors.orange)),
                        if (reward.discountLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(.09),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.green.withOpacity(.18)),
                            ),
                            child: Text(reward.discountLabel!,
                              style: AppTextStyles.body(size: 9.5, weight: FontWeight.w700, color: AppColors.green)),
                          ),
                      ],
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
