import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Manages all audio and sound effects in the app
class AudioService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  /// Initialize audio service
  Future<void> initialize() async {
    // Set audio context for Android
    await _audioPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.media,
        ),
      ),
    );
  }

  /// Toggle mute
  void setMuted(bool muted) {
    _isMuted = muted;
    notifyListeners();
  }

  /// Play level up sound
  Future<void> playLevelUp() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.play(AssetSource('sounds/level_up.mp3'));
      } catch (e) {
        if (kDebugMode) print('Error playing level up sound: $e');
      }
    }
  }

  /// Play task complete sound
  Future<void> playTaskComplete() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.play(AssetSource('sounds/task_complete.mp3'));
      } catch (e) {
        if (kDebugMode) print('Error playing task complete sound: $e');
      }
    }
  }

  /// Play badge unlock sound
  Future<void> playBadgeUnlock() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.play(AssetSource('sounds/badge_unlock.mp3'));
      } catch (e) {
        if (kDebugMode) print('Error playing badge unlock sound: $e');
      }
    }
  }

  /// Play generic UI click sound
  Future<void> playClick() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.play(AssetSource('sounds/click.mp3'));
      } catch (e) {
        if (kDebugMode) print('Error playing click sound: $e');
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
