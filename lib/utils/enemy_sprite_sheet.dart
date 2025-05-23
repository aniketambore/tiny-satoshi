import 'package:bonfire/bonfire.dart';

class EnemySpriteSheet {
  static Future<SpriteAnimation> enemyAttackEffectRight() =>
      SpriteAnimation.load(
        'enemy/atack_effect_right.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );

  static Future<SpriteAnimation> goblinIdleRight() => SpriteAnimation.load(
    'enemy/goblin/goblin_idle.png',
    SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> goblinIdleLeft() => SpriteAnimation.load(
    'enemy/goblin/goblin_idle_left.png',
    SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static SimpleDirectionAnimation goblinAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: goblinIdleLeft(),
        idleRight: goblinIdleRight(),
        runLeft: SpriteAnimation.load(
          'enemy/goblin/goblin_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/goblin/goblin_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
      );

  static Future<SpriteAnimation> impIdleLeft() => SpriteAnimation.load(
    'enemy/imp/imp_idle_left.png',
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static Future<SpriteAnimation> impIdleRight() => SpriteAnimation.load(
    'enemy/imp/imp_idle.png',
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
  );

  static SimpleDirectionAnimation impAnimations() => SimpleDirectionAnimation(
    idleLeft: impIdleLeft(),
    idleRight: impIdleRight(),
    runLeft: SpriteAnimation.load(
      'enemy/imp/imp_run_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
    runRight: SpriteAnimation.load(
      'enemy/imp/imp_run_right.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(16, 16),
      ),
    ),
  );

  static Future<SpriteAnimation> miniBossIdleRight() => SpriteAnimation.load(
    'enemy/mini_boss/mini_boss_idle.png',
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2(16, 24),
    ),
  );

  static SimpleDirectionAnimation miniBossAnimations() =>
      SimpleDirectionAnimation(
        idleLeft: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_idle_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
        idleRight: miniBossIdleRight(),
        runLeft: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_run_left.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
        runRight: SpriteAnimation.load(
          'enemy/mini_boss/mini_boss_run_right.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: 0.1,
            textureSize: Vector2(16, 24),
          ),
        ),
      );

  static Future<SpriteAnimation> bossIdleRight() => SpriteAnimation.load(
    'enemy/boss/boss_idle.png',
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2(32, 36),
    ),
  );

  static SimpleDirectionAnimation bossAnimations() => SimpleDirectionAnimation(
    idleLeft: SpriteAnimation.load(
      'enemy/boss/boss_idle_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
    idleRight: bossIdleRight(),
    runLeft: SpriteAnimation.load(
      'enemy/boss/boss_run_left.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
    runRight: SpriteAnimation.load(
      'enemy/boss/boss_run_right.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 36),
      ),
    ),
  );
}
