import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/game/game_cubit.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/utils/enemy_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';

class MiniBoss extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 50;
  bool _seePlayerClose = false;
  bool _isInDialog = false;

  MiniBoss(this.initPosition)
    : super(
        animation: EnemySpriteSheet.miniBossAnimations(),
        position: initPosition,
        size: Vector2(tileSize * 0.68, tileSize * 0.93),
        speed: tileSize * 1.5,
        life: 150,
      );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(valueByTileSize(6), valueByTileSize(7)),
        position: Vector2(valueByTileSize(2.5), valueByTileSize(8)),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameCubit = context.read<GameCubit>();
    final gameState = gameCubit.state;

    if (!gameState.hasMiniBossShownDialog && !_isInDialog) {
      seePlayer(
        observed: (p) {
          gameCubit.setMiniBossDialogShown(true);
          _showDialog();
        },
        radiusVision: tileSize * 5,
      );
    }

    if (!_isInDialog) {
      _seePlayerClose = false;
      seePlayer(
        observed: (player) {
          _seePlayerClose = true;
          seeAndMoveToPlayer(
            closePlayer: (player) {
              execAttack();
            },
            radiusVision: tileSize * 3,
          );
        },
        radiusVision: tileSize * 3,
      );
      if (!_seePlayerClose) {
        seeAndMoveToAttackRange(
          positioned: (p) {
            execAttackRange();
          },
          radiusVision: tileSize * 5,
        );
      }
    }
  }

  void _showDialog() {
    _isInDialog = true;
    if (gameRef.player != null) {
      gameRef.player!.idle();
    }
    // Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  "Oh look, another satoshi! Come to claim the legendary Bitcoin chest? *smirks*",
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.miniBossIdleRight(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  "Yes! I've heard tales of its riches. I need to fill my wallet!",
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight,
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  "Oh, the chest is full alright... *chuckles* But you'll have to get past me first!",
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.miniBossIdleRight(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onFinish: () {
        _isInDialog = false;
        // Sounds.interaction();
      },
    );
  }

  void execAttackRange() {
    simpleAttackRange(
      animation: GameSpriteSheet.fireBallAttackRight(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2.all(tileSize * 0.65),
      damage: attack,
      speed: speed * 2.5,
      execute: () {
        // Sounds.attackRange();
      },
      onDestroy: () {
        // Sounds.explosion();
      },
      collision: RectangleHitbox(
        size: Vector2(tileSize / 3, tileSize / 3),
        position: Vector2(10, 5),
      ),
      lightingConfig: LightingConfig(
        radius: tileSize * 0.9,
        blurBorder: tileSize / 2,
        color: Colors.deepOrangeAccent.withValues(alpha: 0.4),
      ),
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: attack / 3,
      interval: 300,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        // Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void onReceiveDamage(
    AttackOriginEnum attacker,
    double damage,
    dynamic identify,
  ) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.onReceiveDamage(attacker, damage, identify);
  }

  @override
  void onDie() {
    _showDeathDialog();
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.smokeExplosion(),
        position: position,
        size: Vector2.all(tileSize),
        loop: false,
      ),
    );
    removeFromParent();
    super.onDie();
  }

  void _showDeathDialog() {
    if (gameRef.player != null) {
      gameRef.player!.idle();
    }
    // Sounds.interaction();
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(text: "You... you actually beat me... *coughs weakly*"),
        ],
        person: CustomSpriteAnimationWidget(
          animation: EnemySpriteSheet.miniBossIdleRight(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [TextSpan(text: "But before I go... *laughs through pain*")],
        person: CustomSpriteAnimationWidget(
          animation: EnemySpriteSheet.miniBossIdleRight(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
            text:
                "That chest has been empty for centuries, you fool! *dies laughing*",
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: EnemySpriteSheet.miniBossIdleRight(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ]);
  }
}
