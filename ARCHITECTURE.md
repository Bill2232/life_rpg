# Solo Leveling Architecture Documentation

## Project Overview

**Solo Leveling** is a Flutter-based real-life RPG productivity and self-improvement application. Users gain XP and level up by completing real-world tasks and habits, unlocking avatars, badges, and achievements.

## Architecture Overview

The app follows a **Clean Architecture** pattern with clear separation of concerns:

```
lib/
├── config/              # App configuration and constants
├── models/              # Data models
├── providers/           # State management (Provider pattern)
├── services/            # Business logic and external services
├── screens/             # UI screens/pages
├── widgets/             # Reusable widgets
├── theme/               # Theme and design system
└── main.dart            # App entry point
```

## Core Components

### 1. **Models** (`lib/models/`)

#### `player.dart`
- **Player**: Main game entity with XP, level, avatar evolution, badges, and statistics
- Manages progression through level system
- Tracks task completions and streaks
- Persists data to Hive local storage

#### `badge.dart`
- **Badge**: Achievement system with unlock conditions
- Supports level-based and XP-based unlocks
- Tracks unlock dates and progress

#### `task.dart`
- **Task**: Daily, Main, and Side quest types
- Tracks completion, streaks, and XP rewards
- Streak bonus system for daily tasks

#### `user.dart`
- **User**: Authentication model (for future online features)
- Email, display name, profile information

### 2. **Services** (`lib/services/`)

#### `audio_service.dart`
- Sound effects management (level up, task complete, badge unlock)
- Mute toggle functionality
- Integrates with `audioplayers` package

#### `settings_service.dart`
- Persistent user preferences (dark mode, sound, notifications, language)
- Uses `shared_preferences` for storage
- Extends `ChangeNotifier` for reactive updates

#### `notification_service.dart`
- Local push notifications
- Daily reminders and achievement notifications
- Integrates with `flutter_local_notifications`

### 3. **Providers** (`lib/providers/`)

#### `game_provider.dart`
- **GameProvider**: Central game state management
- Manages player progression and task completion
- Handles badge unlocking logic
- Coordinates between audio, notifications, and persistence

#### `auth_provider.dart`
- **AuthProvider**: Authentication state management
- Sign in/up with email, Google Sign-In
- Session persistence
- (Ready for Firebase integration)

### 4. **Screens** (`lib/screens/`)

#### `home_screen.dart`
- Main task dashboard with bottom navigation
- Task filtering by type (Daily, Main, Side)
- Player profile header with avatar and XP bar
- Transitions to Stats, Badges, and Settings tabs

#### `stats_screen.dart`
- Comprehensive player statistics
- Level, XP, streak tracking
- Weekly performance graph (fl_chart)
- Account creation and activity dates

#### `badges_screen.dart`
- Unlocked and locked badge display (tab-based)
- Badge details modal
- Progress bar showing unlock percentage
- Conditions for each badge

#### `settings_screen.dart`
- Display settings (dark/light mode)
- Sound and notification toggles
- Language selection
- Username editing
- Progress reset (with confirmation)

### 5. **Widgets** (`lib/widgets/`)

#### `xp_bar.dart`
- Animated XP progress display
- Shows current XP / XP to next level
- Smooth progress animation

#### `task_card.dart`
- Individual task display
- Type-based color coding and icons
- Animated task completion
- Streak display for daily tasks
- Quick-complete button

#### `weekly_graph.dart`
- Weekly performance visualization
- Uses `fl_chart` for line graph

### 6. **Theme** (`lib/theme/`)

#### `app_theme.dart`
- **AppColors**: Consistent color palette
  - Primary: Indigo (#6366F1)
  - Accent: Amber (#F59E0B)
  - Success: Emerald (#10B981)
  - Error: Red (#EF4444)
  
- **AppTextStyles**: Standardized text styles
  - Headings (h1, h2, h3)
  - Body text (body1, body2)
  - Labels and buttons
  
- **Light and Dark Themes**: Complete Material 3 theme definitions

### 7. **Configuration** (`lib/config/`)

#### `app_config.dart`
- Central configuration constants
- XP progression settings
- Avatar evolution thresholds
- Hive box names
- Notification channel config

## State Management

### Provider Pattern
- Uses `provider` package for reactive state
- **GameProvider**: Game logic and player state
- **AuthProvider**: Authentication state
- **SettingsService**: User preferences

### Local Persistence
- **Hive**: Fast local NoSQL database for player data and tasks
- **SharedPreferences**: User settings (theme, sound, notifications)

### Dependency Injection
- **GetIt**: Service locator for singleton management
- Services initialized in `main.dart`
- Easy testing and mocking

## Data Flow

```
User Action (Task Complete)
    ↓
HomeScreen calls GameProvider.completeTask()
    ↓
GameProvider updates Player model & task state
    ↓
Player.addXP() with optional level up
    ↓
Badge check & unlock logic
    ↓
Audio service plays sound (if enabled)
    ↓
Notification service sends notification
    ↓
Save to Hive persistence
    ↓
notifyListeners() → UI rebuild
```

## Key Features Implemented

### ✅ Gamification System
- XP progression with configurable increments
- Level-based avatar evolution (3 stages)
- Badge system with unlock conditions
- Streak tracking with bonus XP
- Statistics tracking

### ✅ Settings Management
- Dark/Light mode toggle
- Sound effects toggle
- Notification preferences
- Language readiness (framework in place)
- Progress reset option

### ✅ UI/UX
- Clean Material 3 design system
- Animated transitions and progress bars
- Tab-based navigation
- Bottom navigation for main sections
- Modal dialogs for confirmations

### ✅ Persistence
- Hive for game data (player, tasks, badges)
- SharedPreferences for settings
- Automatic save on data changes

### ✅ Audio & Notifications
- Sound effects for level up, task complete, badge unlock
- Local push notifications
- Notification service integration

## Future Features (Framework Ready)

### Authentication System
- Firebase Email/Password authentication
- Google Sign-In integration
- Session persistence
- Password reset flow

### Online Multiplayer (Architecture prepared)
- Friends system
- Challenge/competition mechanics
- Global leaderboards
- Record-breaking notifications
- Cooperative tasks

### Enhanced Features
- Custom task creation UI
- Task categories and filtering
- Habit tracking
- Weekly challenges
- Social sharing
- Cloud backup and sync

## Configuration & Constants

All app-wide constants are centralized in `AppConfig`:

```dart
AppConfig.baseXpToLevel = 150        // XP required for first level
AppConfig.xpIncrement = 25           // Additional XP per level
AppConfig.streakBonus = 5            // XP bonus per streak day
AppConfig.avatarStage1Threshold = 3  // Level to unlock avatar stage 1
AppConfig.avatarStage2Threshold = 6  // Level to unlock avatar stage 2
AppConfig.avatarStage3Threshold = 10 // Level to unlock avatar stage 3
```

## Testing Considerations

- Providers extend `ChangeNotifier` for mockable state
- Services are singletons registered with GetIt
- Models are simple data classes without dependencies
- UI is decoupled from business logic

## Package Dependencies

```yaml
# State Management
provider: ^6.1.0
get_it: ^7.6.0

# Storage & Persistence  
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.2.2

# Authentication (Ready)
firebase_core: ^3.15.2
firebase_auth: ^5.1.0
google_sign_in: ^6.1.6

# Audio & Notifications
audioplayers: ^5.2.1
flutter_local_notifications: ^17.0.0

# Charts & Visualization
fl_chart: ^0.66.2

# Animations & UI
animations: ^2.0.11
lottie: ^2.7.0

# Utilities
intl: ^0.19.0
```

## Development Workflow

1. **Add Feature**: Create models → services → providers → UI
2. **State Changes**: Update provider, listen in UI with Consumer
3. **Persistence**: Call model.save() after state changes
4. **Audio/Notifications**: Request from services via provider
5. **Testing**: Mock providers and services with GetIt

## Code Organization Principles

- **Single Responsibility**: Each class has one reason to change
- **Dependency Injection**: Services provided via GetIt
- **Reactive UI**: UI observes providers via Consumer widgets
- **Centralized Configuration**: AppConfig for all constants
- **Consistent Styling**: AppColors, AppTextStyles for design system
- **Error Handling**: Providers expose error states for UI

---

**Version**: 1.0.0  
**Last Updated**: January 2026
