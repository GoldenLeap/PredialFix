import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundNavigationObserver extends NavigatorObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sound/nuossa.mp3'));
    } catch (e) {
      debugPrint('Nuossa erro $e');
    }
  }

  @override 
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null) {
      _playSound();
    }
  }

  @override 
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _playSound();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _playSound();
  }
}