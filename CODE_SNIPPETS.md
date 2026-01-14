# Solo Leveling - Code Snippets & Quick Reference

## Common Tasks & Code Examples

### 1. Complete a Task (From UI)

```dart
// In a screen, call:
context.read<GameProvider>().completeTask(task);

// Or with Consumer:
Consumer<GameProvider>(
  builder: (context, gameProvider, _) {
    return ElevatedButton(
      onPressed: () => gameProvider.completeTask(task),
      child: Text('Complete'),
    );
  },
)
```

### 2. Add a New Task Programmatically

```dart
final newTask = Task(
  title: "Learn Flutter",
  type: TaskType.main,
  xp: 100,
);

context.read<GameProvider>().addTask(newTask);
```

### 3. Get Current Player Stats

```dart
final player = context.read<GameProvider>().player;
print('Level: ${player.level}');
print('XP: ${player.xp}/${player.xpToNext}');
print('Badges: ${player.getUnlockedBadges().length}');
```

### 4. Update Settings

```dart
final settings = context.read<SettingsService>();
await settings.setDarkMode(true);
await settings.setSoundEnabled(false);
await settings.setLanguage('en');
```

### 5. Play a Sound

```dart
final audioService = context.read<AudioService>();
await audioService.playLevelUp();
// or
await audioService.playTaskComplete();
await audioService.playBadgeUnlock();
```

### 6. Send a Notification

```dart
NotificationService.showNotification(
  "Title",
  "This is the body text",
);
```

### 7. Unlock a Badge

```dart
player.unlockBadge('first_step');
player.save();
```

### 8. Access Hive Data Directly

```dart
final box = Hive.box(AppConfig.userBox);
final savedLevel = box.get('level', defaultValue: 1);
box.put('customKey', 'customValue');
```

## Widget Examples

### XP Bar
```dart
XPBar(
  xp: player.xp,
  max: player.xpToNext,
  animated: true,
)
```

### Task Card
```dart
TaskCard(
  task: task,
  onComplete: () => completeTask(task),
)
```

### Custom Card
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Content', style: AppTextStyles.heading3),
      ],
    ),
  ),
)
```

## Routing Examples

### Navigate to Screen
```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => StatsScreen()),
);
```

### Replace Screen
```dart
Navigator.of(context).pushReplacementNamed('/home');
```

### Pop Screen
```dart
Navigator.of(context).pop();
```

## State Management Patterns

### Provider Pattern (Best Practice)
```dart
// Reading state
final gameProvider = context.read<GameProvider>();

// Listening to changes
context.listen<GameProvider>(
  (previous, next) {
    print('Player level changed: ${next.player.level}');
  },
);

// Building with changes
Consumer<GameProvider>(
  builder: (context, gameProvider, child) {
    return Text('Level: ${gameProvider.player.level}');
  },
)
```

### Multiple Providers
```dart
Consumer2<GameProvider, SettingsService>(
  builder: (context, gameProvider, settingsService, _) {
    return Text(
      'Level: ${gameProvider.player.level}',
      style: TextStyle(
        color: settingsService.isDarkMode 
          ? Colors.white 
          : Colors.black,
      ),
    );
  },
)
```

## Data Persistence Examples

### Save Player Data
```dart
player.username = "NewName";
player.save(); // Automatically saves to Hive
```

### Load Player Data
```dart
Player player = Player();
player.load(); // Loads from Hive
```

### Save Custom Data to Hive
```dart
final box = Hive.box(AppConfig.userBox);
box.put('lastLoginTime', DateTime.now().toIso8601String());
```

### Load Custom Data
```dart
final box = Hive.box(AppConfig.userBox);
final lastLogin = box.get('lastLoginTime');
```

## Animation Examples

### Fade In Animation
```dart
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: Text('Appears/Disappears'),
)
```

### Scale Animation
```dart
ScaleTransition(
  scale: animation,
  child: Icon(Icons.star),
)
```

### Slide Animation
```dart
SlideTransition(
  position: animation,
  child: Container(),
)
```

## Form Examples

### Simple Text Input
```dart
TextField(
  controller: controller,
  decoration: InputDecoration(
    hintText: 'Enter text',
    prefixIcon: Icon(Icons.person),
  ),
)
```

### Email Input
```dart
TextField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    hintText: 'Email',
    prefixIcon: Icon(Icons.email),
  ),
)
```

### Password Input
```dart
TextField(
  controller: passwordController,
  obscureText: true,
  decoration: InputDecoration(
    hintText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
)
```

## Dialog Examples

### Simple Alert Dialog
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirmation'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Do something
          Navigator.pop(context);
        },
        child: Text('OK'),
      ),
    ],
  ),
);
```

### Bottom Sheet
```dart
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Bottom Sheet Content'),
      ],
    ),
  ),
);
```

## Snackbar Examples

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Action completed!'),
    duration: Duration(seconds: 3),
  ),
);
```

## Debugging Tips

### Print Provider State
```dart
final gameProvider = context.read<GameProvider>();
print('Player: ${gameProvider.player.username}');
print('Tasks: ${gameProvider.tasks.length}');
```

### Check Hive Data
```dart
final box = Hive.box(AppConfig.userBox);
print('Box contents: ${box.toMap()}');
```

### Monitor Provider Updates
```dart
context.listen<GameProvider>(
  (previous, next) {
    print('GameProvider updated');
    print('Level: ${previous?.player.level} -> ${next.player.level}');
  },
);
```

### Test Audio Service
```dart
final audioService = context.read<AudioService>();
audioService.playLevelUp();
print('Audio muted: ${audioService.isMuted}');
```

## Useful Constants

```dart
// From AppConfig
final baseXp = AppConfig.baseXpToLevel;           // 150
final xpInc = AppConfig.xpIncrement;             // 25
final bonus = AppConfig.streakBonus;             // 5
final level3 = AppConfig.avatarStage1Threshold; // 3
final level6 = AppConfig.avatarStage2Threshold; // 6
final level10 = AppConfig.avatarStage3Threshold; // 10
```

## Performance Tips

### Lazy Load Screens
```dart
class LazyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return MainContent();
      },
    );
  }
}
```

### Avoid Rebuilds
```dart
// BAD - rebuilds entire tree
ListView(children: [for (var item in items) ItemWidget(item)])

// GOOD - only rebuilds changed items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### Cache Complex Computations
```dart
class CachedComputation {
  static Map<String, dynamic> _cache = {};
  
  static int getPlayerStats(Player player) {
    String key = 'stats_${player.level}';
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    // Compute...
    return _cache[key] = result;
  }
}
```

## Common Errors & Solutions

### Error: "Hive box not opened"
```dart
// Solution: Call in main.dart
await Hive.openBox(AppConfig.userBox);
```

### Error: "Provider not found"
```dart
// Solution: Wrap with MultiProvider
MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: gameProvider),
  ],
  child: MyApp(),
)
```

### Error: "NotificationService not initialized"
```dart
// Solution: Initialize in main.dart
NotificationService.initialize(notificationsPlugin);
```

### UI not updating on provider change
```dart
// Solution: Use Consumer instead of direct context.read()
Consumer<GameProvider>(
  builder: (context, gameProvider, _) {
    return Text('Level: ${gameProvider.player.level}');
  },
)
```

---

## Quick Command Reference

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Build APK
flutter build apk --target-platform android-arm64

# Build for iOS
flutter build ios

# Profile app
flutter run --profile

# Release build
flutter run --release
```

---

**Last Updated**: January 2026
