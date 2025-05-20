import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiny_satoshi/enemies/imp.dart';
import 'package:tiny_satoshi/enemies/mini_boss.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/utils/enemy_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/npc_spritesheet.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';

class Boss extends SimpleEnemy with BlockMovementCollision, UseLifeBar {
  final Vector2 initPosition;
  double attack = 40;

  bool firstSeePlayer = false;
  List<Enemy> childrenEnemy = [];

  Boss(this.initPosition)
    : super(
        animation: EnemySpriteSheet.bossAnimations(),
        position: initPosition,
        size: Vector2(tileSize * 1.5, tileSize * 1.7),
        speed: tileSize * 1.5,
        life: 200,
      );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(valueByTileSize(14), valueByTileSize(16)),
        position: Vector2(valueByTileSize(5), valueByTileSize(11)),
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    drawBarSummonEnemy(canvas);
    super.render(canvas);
  }

  void drawBarSummonEnemy(Canvas canvas) {
    double yPosition = 0;
    double widthBar = (width - 10) / 3;
    if (childrenEnemy.isEmpty) {
      canvas.drawLine(
        Offset(0, yPosition),
        Offset(widthBar, yPosition),
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 1
          ..style = PaintingStyle.fill,
      );
    }

    double lastX = widthBar + 5;
    if (childrenEnemy.length < 2) {
      canvas.drawLine(
        Offset(lastX, yPosition),
        Offset(lastX + widthBar, yPosition),
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 1
          ..style = PaintingStyle.fill,
      );
    }

    lastX = lastX + widthBar + 5;
    if (childrenEnemy.length < 3) {
      canvas.drawLine(
        Offset(lastX, yPosition),
        Offset(lastX + widthBar, yPosition),
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 1
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  void update(double dt) {
    if (!firstSeePlayer) {
      seePlayer(
        observed: (p) {
          firstSeePlayer = true;
          gameRef.camera.moveToTargetAnimated(
            target: this,
            zoom: 2,
            onComplete: _showConversation,
          );
        },
        radiusVision: tileSize * 6,
      );
    }

    if (life < 150 && childrenEnemy.isEmpty) {
      addChildInMap(dt);
    }

    if (life < 100 && childrenEnemy.length == 1) {
      addChildInMap(dt);
    }

    if (life < 50 && childrenEnemy.length == 2) {
      addChildInMap(dt);
    }

    seeAndMoveToPlayer(
      closePlayer: (player) {
        execAttack();
      },
      radiusVision: tileSize * 4,
    );

    super.update(dt);
  }

  void addChildInMap(double dt) {
    if (checkInterval('addChild', 2000, dt)) {
      Vector2 positionExplosion = Vector2.zero();

      switch (directionThePlayerIsIn()) {
        case Direction.left:
          positionExplosion = position.translated(width * -2, 0);
          break;
        case Direction.right:
          positionExplosion = position.translated(width * 2, 0);
          break;
        case Direction.up:
          positionExplosion = position.translated(0, height * -2);
          break;
        case Direction.down:
          positionExplosion = position.translated(0, height * 2);
          break;
        case Direction.upLeft:
        case Direction.upRight:
        case Direction.downLeft:
        case Direction.downRight:
          break;
        default:
      }

      Enemy e =
          childrenEnemy.length == 2
              ? MiniBoss(Vector2(positionExplosion.x, positionExplosion.y))
              : Imp(Vector2(positionExplosion.x, positionExplosion.y));

      gameRef.add(
        AnimatedGameObject(
          animation: GameSpriteSheet.smokeExplosion(),
          position: positionExplosion,
          size: Vector2(32, 32),
          loop: false,
        ),
      );

      childrenEnemy.add(e);
      gameRef.add(e);
    }
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(tileSize * 0.62),
      damage: attack,
      interval: 1500,
      animationRight: EnemySpriteSheet.enemyAttackEffectRight(),
      execute: () {
        // Sounds.attackEnemyMelee();
      },
    );
  }

  void _showConversation() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: 'Heeeelp! Heeeelp!')],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Shut up, you little Bitcoin thief! Your wallet will be mine, and I\'ll be the one to enter the final door! *laughs maniacally*',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.bossIdleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Stay away from that kid! Your days of stealing Bitcoin wallets are over!',
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
                  'Another hero trying to protect the weak? *laughs* I\'ve been collecting Bitcoin wallets for centuries. This one will be mine!',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: EnemySpriteSheet.bossIdleRight(),
          ),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onFinish: () {
        addInitChild();
        Future.delayed(Duration(milliseconds: 500), () {
          gameRef.camera.moveToPlayerAnimated(zoom: 1);
        });
      },
      onChangeTalk: (index) {
        // Sounds.interaction();
      },
      logicalKeyboardKeysToNext: [LogicalKeyboardKey.space],
    );
  }

  void addInitChild() {
    addImp(width * -2, 0);
    addImp(width * -2, width);
  }

  void addImp(double x, double y) {
    final p = position.translated(x, y);
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.smokeExplosion(),
        position: p,
        size: Vector2.all(tileSize),
        loop: false,
      ),
    );
    gameRef.add(Imp(p));
  }

  @override
  void onDie() {
    gameRef.add(
      AnimatedGameObject(
        animation: GameSpriteSheet.explosion(),
        position: position,
        size: Vector2(32, 32),
        loop: false,
      ),
    );
    for (var e in childrenEnemy) {
      if (!e.isDead) e.onDie();
    }
    removeFromParent();
    super.onDie();
  }
}
