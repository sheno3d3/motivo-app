# Motivo Flutter App

> **Every Step Has Value** — Walk-to-earn fitness rewards app

---

## Project Structure

```
motivo/
├── lib/
│   ├── main.dart                    # App entry + bottom nav shell
│   ├── theme/
│   │   └── app_theme.dart           # Colors, typography, theme config
│   ├── models/
│   │   └── models.dart              # Data models + sample data
│   ├── widgets/
│   │   └── glass_widgets.dart       # Reusable glass UI components
│   └── screens/
│       ├── home_screen.dart         # Home: steps ring, coins, missions, offers
│       ├── missions_screen.dart     # Missions: tabbed daily/weekly/golden/social
│       ├── rewards_screen.dart      # Rewards: wallet, referral, offers grid
│       └── profile_screen.dart      # Profile: stats, streak, menu
├── assets/
│   └── fonts/                       # Playfair Display font files
└── pubspec.yaml
```

---

## Setup Instructions

### 1. Install Flutter
```bash
# Check if Flutter is installed
flutter --version

# If not: https://docs.flutter.dev/get-started/install
```

### 2. Clone / open project
```bash
cd motivo
flutter pub get
```

### 3. Add Playfair Display fonts
Download from Google Fonts → place in `assets/fonts/`:
- `PlayfairDisplay-Regular.ttf`
- `PlayfairDisplay-Bold.ttf`
- `PlayfairDisplay-Black.ttf`

Or use `google_fonts` package instead (already in pubspec) and remove the manual font declaration.

### 4. Run on device
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Or use VS Code / Android Studio
```

---

## Key Features

| Feature | Implementation |
|---|---|
| Glass UI | `BackdropFilter + ClipRRect` on every card |
| Ambient orbs | Animated positioned containers with blur shadows |
| Step ring | Custom `CustomPainter` with sweep gradient + glow |
| Coin glow | `AnimationController` looping box-shadow |
| Mission tabs | `TabController` with custom glass `TabBar` |
| Progress bars | `TweenAnimationBuilder` smooth fill |
| Modals | `showModalBottomSheet` with glass sheet |
| Page nav | `PageView` with `HapticFeedback` |
| Animations | `flutter_animate` package (staggered reveals) |

---

## Brand Colors

```dart
static const Color orange   = Color(0xFFFF6B35);  // Primary CTA
static const Color orangeDark = Color(0xFFD94F1E); // Gradient end
static const Color gold     = Color(0xFFF5C842);  // Coins / rewards
static const Color navy     = Color(0xFF04090F);  // Background
static const Color green    = Color(0xFF00C896);  // Success / earned
static const Color blue     = Color(0xFF2F78FF);  // Social / affiliate
```

---

## Typography

| Role | Font | Size | Weight |
|---|---|---|---|
| Display / Numbers | Playfair Display | 22–54px | 700–900 |
| Headings | Playfair Display | 18–22px | 700 |
| Body / UI | Inter (Google Fonts) | 11–15px | 400–700 |
| Labels / Badges | Inter | 9–10.5px | 600–700 |

---

## Next Steps for Developer

1. **Connect real step counting** → `pedometer` package in `pubspec.yaml`
2. **Health integration** → `health` package (Apple Health / Google Fit)
3. **Backend API** → Replace `SampleData` with `Dio` HTTP calls
4. **Auth** → Add Firebase Auth or Supabase
5. **Push notifications** → `firebase_messaging`
6. **State management** → Wire `flutter_riverpod` providers
7. **App icons** → Run `flutter_launcher_icons` with Motivo brand assets
8. **Splash screen** → `flutter_native_splash`

---

## Screens Overview

### Home
- Greeting + notification bell
- Animated step ring (custom painter, sweep gradient)
- Live stat chips (km, kcal, min, streak)
- Glowing coin balance card
- Horizontal scrollable mission strip cards
- Horizontal offer carousel
- Affiliate brand row

### Missions
- Header with level pill
- Glass tab bar (Daily / Weekly / Golden ★ / Social)
- Full mission cards with hero icon, progress bar, chips, CTA button
- Bottom sheet modal for each mission

### Rewards
- Wallet card (total balance, available/pending/used pills)
- Referral code card with clipboard copy
- 2-column reward grid with redeem modals

### Profile
- Avatar with glow ring
- Streak card with fire animation
- 3×2 stats grid
- Menu list with icon containers, badges, arrows

---

*Built with Flutter 3.x · Dart 3.x · Google Fonts (Inter + Playfair Display)*
