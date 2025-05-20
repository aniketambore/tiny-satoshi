import 'package:bonfire/bonfire.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';

class Spikes extends GameDecoration with Sensor<Knight> {
  final double damage;
  Knight? player;

  Spikes(Vector2 position, {this.damage = 20})
    : super.withAnimation(
        animation: GameSpriteSheet.spikes(),
        position: position,
        size: Vector2(tileSize, tileSize),
      );

  @override
  void onContact(Knight component) {
    player = component;
  }

  @override
  void update(double dt) {
    if (isAnimationLastFrame) {
      player?.handleAttack(AttackOriginEnum.ENEMY, damage, 0);
    }
    super.update(dt);
  }

  @override
  int get priority => LayerPriority.getComponentPriority(1);

  @override
  void onContactExit(Knight component) {
    player = null;
  }
}
