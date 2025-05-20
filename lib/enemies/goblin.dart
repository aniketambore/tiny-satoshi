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

class Goblin extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 25;
  bool _isInDialog = false;

  Goblin(this.initPosition)
    : super(
        animation: EnemySpriteSheet.goblinAnimations(),
        position: initPosition,
        size: Vector2.all(tileSize * 0.8),
        speed: tileSize * 1.5,
        life: 120,
      );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(valueByTileSize(7), valueByTileSize(7)),
        position: Vector2(valueByTileSize(3), valueByTileSize(4)),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final gameCubit = context.read<GameCubit>();
    final gameState = gameCubit.state;

    if (!gameState.hasGoblinShownDialog && !_isInDialog) {
      seePlayer(
        observed: (p) {
          gameCubit.setGoblinDialogShown(true);
          _showDialog();
        },
        radiusVision: tileSize * 4,
      );
    }

    if (!_isInDialog) {
      seeAndMoveToPlayer(
        radiusVision: tileSize * 4,
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
          text: [TextSpan(text: "Halt! This is my tunnel. Pay the toll!")],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.goblinIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [TextSpan(text: 'But I don’t have anything yet!')],
          person: CustomSpriteAnimationWidget(
            animation: PlayerSpriteSheet.idleRight,
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(text: "Empty pockets? I’ll take my toll in punches!"),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.goblinIdleLeft(),
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

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: attack,
      interval: 800,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        // Sounds.attackEnemyMelee();
      },
    );
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, dynamic id) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.onReceiveDamage(attacker, damage, id);
  }
}
