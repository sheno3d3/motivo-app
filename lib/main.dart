// lib/main.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_widgets.dart';
import 'screens/home_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.navy,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MotivoApp());
}

class MotivoApp extends StatelessWidget {
  const MotivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AppShell(),
    );
  }
}

// ── Main Shell ───────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  late final PageController _pageCtrl;

  final _screens = const [
    HomeScreen(),
    MissionsScreen(),
    RewardsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      extendBody: true,
      body: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: PageView(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
            onPageChanged: (i) => setState(() => _currentIndex = i),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Bottom Navigation Bar ────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_outlined,         activeIcon: Icons.home_rounded,          label: 'Home',    hasBadge: false),
    _NavItem(icon: Icons.bolt_outlined,          activeIcon: Icons.bolt_rounded,           label: 'Missions',hasBadge: true),
    _NavItem(icon: Icons.card_giftcard_outlined, activeIcon: Icons.card_giftcard_rounded,  label: 'Rewards', hasBadge: false),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,         label: 'Profile', hasBadge: false),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
        child: Container(
          height: 82 + bottomPad,
          decoration: BoxDecoration(
            color: AppColors.navy.withOpacity(.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: const Border(top: BorderSide(color: AppColors.border1, width: 1)),
          ),
          padding: EdgeInsets.fromLTRB(6, 0, 6, bottomPad + 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedScale(
                            scale: isActive ? 1.12 : 1.0,
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.elasticOut,
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              color: isActive ? AppColors.orange : AppColors.text3,
                              size: 22,
                            ),
                          ),
                          if (item.hasBadge && !isActive)
                            Positioned(
                              top: -2, right: -4,
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
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: AppTextStyles.label(
                          color: isActive ? AppColors.orange : AppColors.text3),
                        child: Text(item.label.toUpperCase()),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool hasBadge;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.hasBadge,
  });
}
