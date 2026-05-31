// lib/models/models.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Mission ────────────────────────────────────────────
enum MissionType { daily, weekly, golden, social, affiliate, referral }
enum MissionStatus { locked, active, completed, claimed }

class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final MissionStatus status;
  final int coinReward;
  final String? extraReward;
  final double progress;        // 0.0 to 1.0
  final String progressLabel;
  final String timeLeft;
  final IconData icon;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.coinReward,
    this.extraReward,
    required this.progress,
    required this.progressLabel,
    required this.timeLeft,
    required this.icon,
  });

  Color get typeColor {
    switch (type) {
      case MissionType.golden: return AppColors.gold;
      case MissionType.daily: return AppColors.orange;
      case MissionType.weekly: return AppColors.orange;
      case MissionType.social: return AppColors.blue;
      case MissionType.affiliate: return AppColors.blue;
      case MissionType.referral: return AppColors.green;
    }
  }

  String get typeLabel {
    switch (type) {
      case MissionType.golden: return '★ Golden';
      case MissionType.daily: return '⚡ Daily';
      case MissionType.weekly: return '📅 Weekly';
      case MissionType.social: return '📱 Social';
      case MissionType.affiliate: return '🔗 Affiliate';
      case MissionType.referral: return '👥 Referral';
    }
  }

  Gradient get cardGradient {
    switch (type) {
      case MissionType.golden:
        return LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.gold.withOpacity(.10), AppColors.goldDark.withOpacity(.06)],
        );
      case MissionType.referral:
      case MissionType.social:
        return LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.green.withOpacity(.10), AppColors.cyan.withOpacity(.06)],
        );
      case MissionType.affiliate:
        return LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.blue.withOpacity(.10), AppColors.cyan.withOpacity(.06)],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.orange.withOpacity(.10), AppColors.orangeDark.withOpacity(.06)],
        );
    }
  }
}

// ─── Reward / Offer ─────────────────────────────────────
enum RewardCategory { fitness, spa, cafe, hotel, aquatics, nutrition, sport }

class Reward {
  final String id;
  final String title;
  final String brand;
  final String description;
  final RewardCategory category;
  final int coinCost;
  final String? discountLabel;
  final Color heroBgStart;
  final Color heroBgEnd;
  final IconData icon;

  const Reward({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.category,
    required this.coinCost,
    this.discountLabel,
    required this.heroBgStart,
    required this.heroBgEnd,
    required this.icon,
  });
}

// ─── User / Wallet ───────────────────────────────────────
class UserProfile {
  final String name;
  final String handle;
  final int totalCoins;
  final int availableCoins;
  final int pendingCoins;
  final int usedCoins;
  final int level;
  final String levelTitle;
  final int streakDays;
  final int bestStreak;
  final int totalSteps;
  final double totalKm;
  final int totalCalories;
  final int missionsCompleted;
  final int rewardsRedeemed;
  final int referrals;
  final String referralCode;

  const UserProfile({
    required this.name,
    required this.handle,
    required this.totalCoins,
    required this.availableCoins,
    required this.pendingCoins,
    required this.usedCoins,
    required this.level,
    required this.levelTitle,
    required this.streakDays,
    required this.bestStreak,
    required this.totalSteps,
    required this.totalKm,
    required this.totalCalories,
    required this.missionsCompleted,
    required this.rewardsRedeemed,
    required this.referrals,
    required this.referralCode,
  });
}

// ─── Daily Stats ─────────────────────────────────────────
class DailyStats {
  final int steps;
  final int stepGoal;
  final double km;
  final int calories;
  final int activeMinutes;
  final int floors;
  final int coinsEarnedToday;

  const DailyStats({
    required this.steps,
    required this.stepGoal,
    required this.km,
    required this.calories,
    required this.activeMinutes,
    required this.floors,
    required this.coinsEarnedToday,
  });

  double get progress => steps / stepGoal;
}

// ─── Sample Data ─────────────────────────────────────────
class SampleData {
  static const UserProfile user = UserProfile(
    name: 'Ahmed Al-Rashid',
    handle: '@ahmed.walks',
    totalCoins: 4560,
    availableCoins: 2340,
    pendingCoins: 2220,
    usedCoins: 1000,
    level: 7,
    levelTitle: 'Trailblazer',
    streakDays: 14,
    bestStreak: 21,
    totalSteps: 2400000,
    totalKm: 1847,
    totalCalories: 84200,
    missionsCompleted: 38,
    rewardsRedeemed: 12,
    referrals: 7,
    referralCode: 'AHMED-X9K2',
  );

  static const DailyStats today = DailyStats(
    steps: 7842,
    stepGoal: 10000,
    km: 5.6,
    calories: 320,
    activeMinutes: 42,
    floors: 12,
    coinsEarnedToday: 120,
  );

  static final List<Mission> dailyMissions = [
    Mission(
      id: 'm1', title: 'Walk 10,000 Steps',
      description: 'Hit your daily step goal before midnight. Steps sync live from your phone. Keep your streak alive every day.',
      type: MissionType.daily, status: MissionStatus.active,
      coinReward: 120, progress: 0.78,
      progressLabel: '7,842 / 10,000 steps',
      timeLeft: '14h left', icon: Icons.directions_walk,
    ),
    Mission(
      id: 'm2', title: 'Hydration Check-in',
      description: 'Log 8 glasses of water via health integration. Mission complete — reward is waiting.',
      type: MissionType.daily, status: MissionStatus.completed,
      coinReward: 50, progress: 1.0,
      progressLabel: 'Completed',
      timeLeft: 'Done', icon: Icons.water_drop_outlined,
    ),
  ];

  static final List<Mission> weeklyMissions = [
    Mission(
      id: 'm3', title: '50,000 Steps This Week',
      description: 'Stack your walks across the week. Every kilometre counts toward this milestone reward.',
      type: MissionType.weekly, status: MissionStatus.active,
      coinReward: 800, progress: 0.62,
      progressLabel: '31,000 / 50,000 steps',
      timeLeft: '4 days left', icon: Icons.emoji_events_outlined,
    ),
    Mission(
      id: 'm4', title: 'Invite 3 Friends',
      description: 'Each friend who registers and takes their first walk earns you 300 coins. Almost there.',
      type: MissionType.referral, status: MissionStatus.active,
      coinReward: 900, progress: 0.66,
      progressLabel: '2 / 3 friends joined',
      timeLeft: '4 days left', icon: Icons.group_outlined,
    ),
  ];

  static final List<Mission> goldenMissions = [
    Mission(
      id: 'm5', title: 'Film Your Walk Journey',
      description: 'Record a 30–60s walk video. Speak your experience. Post on IG/TikTok, tag @motivoapp. Reach 500+ views to unlock a 30% hotel night discount.',
      type: MissionType.golden, status: MissionStatus.active,
      coinReward: 500, extraReward: '30% hotel night',
      progress: 0.85, progressLabel: '8,500 / 10,000 views',
      timeLeft: 'June', icon: Icons.videocam_outlined,
    ),
    Mission(
      id: 'm6', title: 'Write a Partner Review',
      description: 'Visit any Motivo partner venue and write an honest 200+ word review. Verified by team within 24h.',
      type: MissionType.golden, status: MissionStatus.active,
      coinReward: 350, extraReward: 'Free coffee',
      progress: 0.0, progressLabel: 'Not submitted',
      timeLeft: 'Ongoing', icon: Icons.edit_outlined,
    ),
  ];

  static final List<Mission> socialMissions = [
    Mission(
      id: 'm7', title: 'Post with #Motivolife',
      description: 'Share a selfie at any Motivo partner or on your walk. Each verified post earns 100 coins. No monthly limit.',
      type: MissionType.social, status: MissionStatus.active,
      coinReward: 100, progress: 0.0,
      progressLabel: '0 posts this month',
      timeLeft: 'No limit', icon: Icons.camera_alt_outlined,
    ),
    Mission(
      id: 'm8', title: 'Become a Motivo Creator',
      description: 'Record a 60s reel about your Motivo journey. Best content gets featured on @motivoapp. Monthly prize for top creator.',
      type: MissionType.social, status: MissionStatus.active,
      coinReward: 1000, progress: 0.0,
      progressLabel: 'Not started',
      timeLeft: 'Monthly', icon: Icons.mic_outlined,
    ),
  ];

  static final List<Reward> rewards = [
    Reward(
      id: 'r1', title: '1-Day Free Pass', brand: "Gold's Gym",
      description: 'Full gym access — weights, cardio, swimming pool and sauna. Valid at all branches.',
      category: RewardCategory.fitness, coinCost: 600, discountLabel: 'FREE',
      heroBgStart: const Color(0xFF0A1628), heroBgEnd: const Color(0xFF142038),
      icon: Icons.fitness_center,
    ),
    Reward(
      id: 'r2', title: '2-Hour Spa Session', brand: 'Lavanda Spa',
      description: 'Steam, jacuzzi and massage lounge. Full relaxation at any branch.',
      category: RewardCategory.spa, coinCost: 1200, discountLabel: '−40%',
      heroBgStart: const Color(0xFF180A22), heroBgEnd: const Color(0xFF26103A),
      icon: Icons.spa_outlined,
    ),
    Reward(
      id: 'r3', title: 'Free Coffee', brand: 'Brew House',
      description: 'Any hot or cold drink on the menu. Valid at all Brew House locations.',
      category: RewardCategory.cafe, coinCost: 150, discountLabel: 'FREE',
      heroBgStart: const Color(0xFF1E0D00), heroBgEnd: const Color(0xFF361800),
      icon: Icons.coffee_outlined,
    ),
    Reward(
      id: 'r4', title: 'Hotel Night −30%', brand: 'Hilton',
      description: 'Standard room, breakfast included. Valid at all Hilton properties.',
      category: RewardCategory.hotel, coinCost: 2000, discountLabel: '−30%',
      heroBgStart: const Color(0xFF001428), heroBgEnd: const Color(0xFF002044),
      icon: Icons.hotel_outlined,
    ),
    Reward(
      id: 'r5', title: 'Swim Free 1H', brand: 'Aqua Club',
      description: 'Olympic pool. Locker and towel included. One hour.',
      category: RewardCategory.aquatics, coinCost: 400, discountLabel: 'FREE',
      heroBgStart: const Color(0xFF001020), heroBgEnd: const Color(0xFF001E34),
      icon: Icons.pool_outlined,
    ),
    Reward(
      id: 'r6', title: 'Supplement −20%', brand: 'MyProtein',
      description: '20% off your entire cart on MyProtein store.',
      category: RewardCategory.nutrition, coinCost: 300, discountLabel: '−20%',
      heroBgStart: const Color(0xFF0A1A00), heroBgEnd: const Color(0xFF142C00),
      icon: Icons.science_outlined,
    ),
  ];

  static final List<Map<String, dynamic>> affiliates = [
    {'name': 'MyProtein', 'coins': '+200', 'color': AppColors.blue},
    {'name': 'Nike', 'coins': '+150', 'color': AppColors.orange},
    {'name': 'ON Whey', 'coins': '+300', 'color': AppColors.green},
    {'name': 'Garmin', 'coins': '+500', 'color': AppColors.gold},
    {'name': 'Lululemon', 'coins': '+200', 'color': AppColors.rose},
    {'name': 'Optimum', 'coins': '+250', 'color': AppColors.cyan},
  ];
}
