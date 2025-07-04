import 'package:audioplayers/audioplayers.dart';

class HeartbeatAudioController {
  final AudioPlayer _player = AudioPlayer();

  Future<void> start() async {
    await _player.setSource(AssetSource('audio/splash-audio.mp3'));
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.resume();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}