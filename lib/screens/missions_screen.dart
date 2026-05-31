// lib/screens/missions_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/glass_widgets.dart';
import 'home_screen.dart' show MissionModal;

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});
  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _tabs = ['Daily', 'Weekly', 'Golden ★', 'Social'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Missions',
            style: AppTextStyles.display(size: 30, weight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('Complete challenges · Unlock real-world rewards',
            style: AppTextStyles.body(size: 13, color: AppColors.text2)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withOpacity(.18)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, color: AppColors.gold, size: 13),
              const SizedBox(width: 6),
              Text('June 2025 — Level 3 Active',
                style: AppTextStyles.body(size: 11, weight: FontWeight.w600,
                  color: AppColors.gold)),
            ]),
          ),
        ]),
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.glass1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border1),
        ),
        child: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.text3,
          indicator: BoxDecoration(
            gradient: AppColors.orangeGrad,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [BoxShadow(
              color: AppColors.orange.withOpacity(.35), blurRadius: 18)],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          padding: const EdgeInsets.all(3),
          tabs: _tabs.map((t) => Tab(
            height: 36,
            child: Text(t.toUpperCase(),
              style: AppTextStyles.body(size: 9, weight: FontWeight.w700,
                color: Colors.inherit as Color? ?? Colors.white)),
          )).toList(),
        ),
      ),

      const SizedBox(height: 16),

      Expanded(child: TabBarView(
        controller: _tab,
        physics: const BouncingScrollPhysics(),
        children: [
          _MissionList(missions: SampleData.dailyMissions),
          _MissionList(missions: SampleData.weeklyMissions),
          _MissionList(missions: SampleData.goldenMissions),
          _MissionList(missions: SampleData.socialMissions),
        ],
      )),
    ]);
  }
}

class _MissionList extends StatelessWidget {
  final List<Mission> missions;
  const _MissionList({required this.missions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: missions.length,
      itemBuilder: (ctx, i) => BigMissionCard(
        mission: missions[i],
        onTap: () => showModalBottomSheet(
          context: ctx,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => MissionModal(mission: missions[i]),
        ),
      ),
    );
  }
}
