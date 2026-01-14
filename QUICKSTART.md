# Solo Leveling - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
✅ Flutter installed  
✅ A device/emulator ready  

### Step 1: Install Dependencies
```bash
cd life_rpg
flutter pub get
```
**Time: ~2 minutes**

### Step 2: Run the App
```bash
flutter run
```
**Time: ~1 minute**

### Step 3: Test It Out
1. ✅ Complete a task by clicking the checkmark
2. ✅ Watch XP bar fill and level up animation
3. ✅ Go to Settings → toggle Dark Mode
4. ✅ Check Badges and Stats screens
5. ✅ View different task types

**Time: ~2 minutes**

---

## 📱 What You'll See

### Home Screen
- **Top**: Player profile with avatar, name, XP bar, level
- **Middle**: Task list with Daily, Main, and Side quests
- **Bottom**: Navigation tabs for Stats, Badges, Settings

### Your First Session
1. Open app → You're Level 1 Adventurer
2. Complete tasks to gain XP
3. Level up and evolve your avatar
4. Unlock badges for achievements
5. Toggle dark mode in Settings

---

## 🎯 Key Actions

| Action | How | Result |
|--------|-----|--------|
| Complete Task | Tap checkmark ✓ | Gain XP, animations play |
| View Stats | Tap "Stats" tab | See level, streaks, progress |
| View Badges | Tap "Badges" tab | See unlocked achievements |
| Change Theme | Settings → Toggle | Dark/Light mode |
| Edit Name | Settings → Tap name | Change username |
| Reset Progress | Settings → Danger Zone | Start over (confirmation) |

---

## 🔧 Customization (Quick Changes)

### Change XP Requirements
**File**: `lib/config/app_config.dart`
```dart
static const int baseXpToLevel = 150;  // ← Change this
static const int xpIncrement = 25;     // ← Or this
```

### Change Colors
**File**: `lib/theme/app_theme.dart`
```dart
static const Color primary = Color(0xFF6366F1);  // ← Change primary color
static const Color accent = Color(0xFFF59E0B);   // ← Change accent color
```

### Modify Default Tasks
**File**: `lib/providers/game_provider.dart` (in `_loadTasks()`)
```dart
_tasks = [
  Task(title: "Your task here", type: TaskType.daily, xp: 40),
  // Add more tasks
];
```

---

## 📁 Important Files to Know

| File | What It Does |
|------|--------------|
| `lib/config/app_config.dart` | All constants in one place |
| `lib/theme/app_theme.dart` | Colors, fonts, themes |
| `lib/models/player.dart` | Game progression logic |
| `lib/models/badge.dart` | Badge definitions |
| `lib/providers/game_provider.dart` | State management |
| `lib/screens/home_screen.dart` | Main dashboard |
| `pubspec.yaml` | Dependencies & assets |

---

## 🐛 Troubleshooting

### App won't run
```bash
flutter clean
flutter pub get
flutter run
```

### Hive box error
```bash
# Clear app data
adb uninstall com.example.life_rpg  # Android
# or reinstall on iOS
```

### Provider not updating
Check that you're using `Consumer<GameProvider>` in your widget, not `Provider<GameProvider>`

### Audio not playing
- Verify sound files in `assets/sounds/`
- Check AndroidManifest.xml has INTERNET permission

---

## 📚 Full Documentation

For more details, read:
- **`ARCHITECTURE.md`** - How the app is structured
- **`IMPLEMENTATION_GUIDE.md`** - How to add features
- **`CODE_SNIPPETS.md`** - Code examples
- **`PROJECT_SUMMARY.md`** - Full project overview

---

## ✨ Cool Features to Try

### 1. Streak System
- Complete a Daily task 3 days in a row
- Watch bonus XP increase (5 XP per streak day)
- See the 🔥 emoji next to task name

### 2. Avatar Evolution
- Level 1-2: Novice (avatar1)
- Level 3-5: Disciplined (avatar2)
- Level 6+: Relentless (avatar3)

### 3. Badge Unlocking
- First Step: Complete any task
- First Growth: Reach Level 2
- Disciplined: Reach Level 5
- Keep going to unlock more!

### 4. Dark Mode
- Settings → Toggle "Dark Mode"
- App automatically switches themes
- Preference saved for next session

### 5. Statistics
- Track total tasks, XP, streaks
- See weekly performance graph
- View progress timeline

---

## 🎮 Example Gameplay Session

```
Start: Level 1, 0 XP

✓ Complete "Workout" (Daily) 
  → Gain 30 XP (streak 1)
  → Total: 30/150 XP

✓ Complete "Make bed" (Daily)
  → Gain 10 XP (streak 1)  
  → Total: 40/150 XP

✓ Complete "No porn today" (Daily)
  → Gain 40 XP (streak 1)
  → Total: 80/150 XP

✓ Complete "Build app feature" (Main)
  → Gain 120 XP
  → Total: 200 XP

🎉 LEVEL UP! Now Level 2
  → Notifications plays
  → Avatar shows "First Growth"
  → Level 2 badge unlocked!
  → XP resets: 50/175 to Level 3
```

---

## 🔐 Data Safety

### Your data is:
- ✅ Stored locally on your phone
- ✅ Encrypted by Hive
- ✅ Backed up when you reset
- ✅ Never sent anywhere (until Firebase added)

### To backup:
Connect phone → Copy app data folder  
Or use "Settings → Reset" to archive locally

---

## 📞 Quick Help

| Issue | Solution |
|-------|----------|
| App crashes on start | `flutter clean && flutter pub get` |
| Tasks don't save | Check Hive initialization in main.dart |
| Can't level up | Check XP requirements in app_config.dart |
| Dark mode not working | Restart app after toggle |
| No avatar image | Ensure avatar files in assets/avatars/ |

---

## 🚀 Next Steps

1. **Immediate** (Today)
   - [ ] Run app and test basic features
   - [ ] Try completing some tasks
   - [ ] Check all screens work

2. **Soon** (This week)
   - [ ] Add sound files to assets/sounds/
   - [ ] Set up Firebase project
   - [ ] Implement authentication

3. **Later** (Next week)
   - [ ] Test on physical device
   - [ ] Optimize and polish
   - [ ] Prepare for App Store submission

---

## 💡 Pro Tips

- Press empty area on task to dismiss keyboard
- Use Settings → Dark Mode at night
- Tap badge to see unlock details
- Check Stats for weekly performance
- Streak bonuses add up fast!

---

## 🎯 Success Metrics

You're doing great if:
- ✅ App launches without errors
- ✅ Tasks complete with animation
- ✅ XP bar fills smoothly
- ✅ Level up triggers notification
- ✅ Dark mode toggles instantly
- ✅ Badges display correctly
- ✅ Stats show accurate data

---

## 📊 Default Game Settings

```
Base XP to Level: 150
XP Increment per Level: 25 (25 per level thereafter)
Streak Bonus: 5 XP per day
Avatar Evolution:
  - Stage 1: Level 3 (Disciplined)
  - Stage 2: Level 6 (Relentless)
  - Stage 3: Level 10 (Legend)

Default Tasks:
- Daily: "No porn today" (40 XP)
- Daily: "Make bed" (10 XP)
- Daily: "Workout" (30 XP)
- Main: "Build first app feature" (120 XP)
- Main: "Apply for one job" (150 XP)
- Side: "Clean litter box" (15 XP)
```

---

## 🎉 Congratulations!

Your **Solo Leveling** app is ready to use!

This app demonstrates:
- ✅ Real-life RPG mechanics
- ✅ Responsive Material Design
- ✅ Local data persistence
- ✅ Audio & notifications
- ✅ Gamification principles
- ✅ Production-grade architecture

**Enjoy leveling up in real life! 🚀**

---

**Version**: 1.0.0  
**Status**: Ready to Play  
**Last Updated**: January 2026
