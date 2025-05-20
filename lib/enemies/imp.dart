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

class Imp extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 25;
  bool _isInDialog = false;

  Imp(this.initPosition)
    : super(
        animation: EnemySpriteSheet.impAnimations(),
        position: initPosition,
        size: Vector2.all(tileSize * 0.8),
        speed: tileSize * 2,
        life: 150,
      );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(valueByTileSize(6), valueByTileSize(6)),
        position: Vector2(valueByTileSize(3), valueByTileSize(5)),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameCubit = context.read<GameCubit>();
    final gameState = gameCubit.state;

    if (!gameState.hasImpShownDialog && !_isInDialog) {
      seePlayer(
        observed: (p) {
          gameCubit.setImpDialogShown(true);
          _showDialog();
        },
        radiusVision: tileSize * 5,
      );
    }

    if (!_isInDialog) {
      seeAndMoveToPlayer(
        radiusVision: tileSize * 5,
        closePlayer: (player) {
          execAttack();
        },
      );
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
                  "You got past that goblin? Impressive. But I’m not so easy to beat!",
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.impIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: 'Bring it on!')],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight,
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onFinish: () {
        _isInDialog = false;
        // Sounds.interaction();
      },
    );
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: attack,
      interval: 300,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        // Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void onDie() {
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.smokeExplosion(),
        position: position,
        size: Vector2(32, 32),
        loop: false,
      ),
    );
    removeFromParent();
    super.onDie();
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
}
