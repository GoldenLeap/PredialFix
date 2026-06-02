import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundNavigationObserver extends NavigatorObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  DateTime? _lastPlayTime;

  Future<void> _playSound() async {
    final now = DateTime.now();
    if (_lastPlayTime != null && now.difference(_lastPlayTime!).inMilliseconds < 500) {
      return;
    }
    _lastPlayTime = now;

    try {
      _audioPlayer.stop().then((_) {
        _audioPlayer.play(AssetSource('sound/nuossa.mp3'));
      }).catchError((e) {
        debugPrint('Nuossa erro $e');
      });
    } catch (e) {
      debugPrint('Nuossa erro $e');
    }
  }

  @override 
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null && route is PageRoute) {
      _playSound();
    }
  }

  @override 
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute) {
      _playSound();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _playSound();
    }
  }
}