import 'package:flame_audio/flame_audio.dart';

class Sounds {
  static void playBackgroundSound() async {
    await FlameAudio.bgm.stop();
    FlameAudio.bgm.play('sound_bg.ogg');
  }

  static stopBackgroundSound() {
    return FlameAudio.bgm.stop();
  }
}
