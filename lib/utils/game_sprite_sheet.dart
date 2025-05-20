import 'package:bonfire/bonfire.dart';

class GameSpriteSheet {
  static Future<SpriteAnimation> fountain() => SpriteAnimation.load(
    'items/fountain_red_spritesheet.png',
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> fountainBlue() => SpriteAnimation.load(
    'items/fountain_blue_spritesheet.png',
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> basin() => SpriteAnimation.load(
    'items/basin_spritesheet.png',
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> fireBallAttackRight() => SpriteAnimation.load(
    'player/fireball_right.png',
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2(23, 23),
    ),
  );

  static Future<SpriteAnimation> fireBallExplosion() => SpriteAnimation.load(
    'player/explosion_fire.png',
    SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(32, 32),
    ),
  );

  static Future<SpriteAnimation> smokeExplosion() => SpriteAnimation.load(
    'smoke_explosin.png',
    SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> explosion() => SpriteAnimation.load(
    'explosion.png',
    SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2(32, 32),
    ),
  );

  static Future<SpriteAnimation> spikes() => SpriteAnimation.load(
    'items/spikes.png',
    SpriteAnimationData.sequenced(
      amount: 10,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> openTheDoor() => SpriteAnimation.load(
    'items/door_open.png',
    SpriteAnimationData.sequenced(
      amount: 14,
      stepTime: 0.1,
      textureSize: Vector2(32, 32),
    ),
  );

  static Future<SpriteAnimation> chestOpen() => SpriteAnimation.load(
    'items/empty_chest_open.png',
    SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );
}
