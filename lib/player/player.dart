import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/game/game_cubit.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class Knight extends SimplePlayer with Lighting, BlockMovementCollision {
  bool containKey = false;
  bool containChest = false;

  final GameCubit gameCubit;

  double attack = 25; // Base attack damage
  double stamina = 100; // Stamina points for special moves
  bool showObserveEnemy = false; // Tracks if enemy is in sight
  async.Timer? _timerStamina; // Timer for stamina regeneration

  Knight(Vector2 position, {required this.gameCubit})
    : super(
        animation: PlayerSpriteSheet.simpleDirectionAnimation,
        size: Vector2.all(tileSize),
        position: position,
        life: 200,
        speed: tileSize * 2.5,
      ) {
    setupLighting(
      LightingConfig(
        radius: width * 1.5,
        blurBorder: width,
        color: Colors.deepOrangeAccent.withValues(alpha: 0.2),
      ),
    );
    setupMovementByJoystick(intensityEnabled: true);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(valueByTileSize(8), valueByTileSize(8)),
        position: Vector2(valueByTileSize(4), valueByTileSize(8)),
      ),
    );
    return super.onLoad();
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (isDead) return; // Add early return if player is dead

    // Button 0 or Spacebar: Melee Attack
    if (event.id == 0 && event.event == ActionEvent.DOWN) {
      actionAttack();
    }

    if (event.id == LogicalKeyboardKey.space &&
        event.event == ActionEvent.DOWN) {
      actionAttack();
    }

    // Button 1 or Z key: Ranged Attack
    if (event.id == LogicalKeyboardKey.keyZ &&
        event.event == ActionEvent.DOWN) {
      actionAttackRange();
    }

    if (event.id == 1 && event.event == ActionEvent.DOWN) {
      actionAttackRange();
    }

    // Button 2: Show Mnemonic Dialog
    if (event.id == 2 && event.event == ActionEvent.DOWN) {
      if (containKey) {
        // Get the wallet cubit from the context
        final walletCubit = gameRef.context.read<WalletCubit>();

        // Get the mnemonic words
        walletCubit.getMnemonic().then((words) {
          // Show the sacred words dialog
          if (gameRef.context.mounted && words != null) {
            Dialogs.showSacredWordsDialog(gameRef.context, words);
          }
        });
      } else {
        Dialogs.showKeyRequiredDialog(gameRef.context);
      }
    }

    // Button 3: Show Receive Address Dialog
    if (event.id == 3 && event.event == ActionEvent.DOWN) {
      if (containChest) {
        final walletCubit = gameRef.context.read<WalletCubit>();
        walletCubit.getReceiveAddress().then((address) {
          if (gameRef.context.mounted) {
            Dialogs.showReceiveAddressDialog(gameRef.context, address);
          }
        });
      } else {
        Dialogs.showChestRequiredDialog(gameRef.context);
      }
    }

    super.onJoystickAction(event);
  }

  void actionAttack() {
    if (stamina < 15) return; // Check if enough stamina

    decrementStamina(15);
    simpleAttackMelee(
      damage: attack,
      animationRight: PlayerSpriteSheet.attackEffectRight(),
      size: Vector2.all(tileSize),
    );
  }

  void actionAttackRange() {
    if (stamina < 10) return; // Check if enough stamina

    decrementStamina(10);
    simpleAttackRange(
      animationRight: GameSpriteSheet.fireBallAttackRight(),
      animationDestroy: GameSpriteSheet.fireBallExplosion(),
      size: Vector2(tileSize * 0.65, tileSize * 0.65),
      damage: 10,
      speed: speed * 2.5,
      onDestroy: () {
        // Sounds.explosion();
      },
      collision: RectangleHitbox(
        size: Vector2(tileSize / 3, tileSize / 3),
        position: Vector2(10, 5),
      ),
      // Adds light effect to fireball
      lightingConfig: LightingConfig(
        radius: tileSize * 0.9,
        blurBorder: tileSize / 2,
        color: Colors.deepOrangeAccent.withValues(alpha: 0.4),
      ),
    );
  }

  void _verifyStamina() {
    // Cooldown timer to prevent too frequent regeneration
    if (_timerStamina == null) {
      _timerStamina = async.Timer(Duration(milliseconds: 150), () {
        _timerStamina = null;
      });
    } else {
      return;
    }

    // Regenerate stamina
    stamina += 2;
    if (stamina > 100) {
      stamina = 100;
    }
  }

  void decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
  }

  @override
  void update(double dt) {
    if (isDead) return;

    _verifyStamina(); // Regenerate stamina

    // Check for enemies in vision radius
    seeEnemy(
      radiusVision: tileSize * 6,
      notObserved: () {
        showObserveEnemy = false;
      },
      observed: (enemies) {
        if (showObserveEnemy) return;
        showObserveEnemy = true;
        _showEmote(); // Show alert when enemy spotted
      },
    );
    super.update(dt);
  }

  @override
  void onDie() {
    removeFromParent();
    // Add tomb decoration where player died
    gameRef.add(
      GameDecoration.withSprite(
        sprite: Sprite.load('player/crypt.png'),
        position: Vector2(position.x, position.y),
        size: Vector2.all(30),
        lightingConfig: LightingConfig(
          radius: 100,
          blurBorder: 100,
          color: Colors.deepOrangeAccent.withValues(alpha: 0.2),
        ),
      ),
    );
    super.onDie();
  }

  @override
  void onReceiveDamage(
    AttackOriginEnum attacker,
    double damage,
    dynamic identify,
  ) {
    if (isDead) return;
    // Show floating damage number
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.orange,
        fontFamily: 'Normal',
      ),
    );
    super.onReceiveDamage(attacker, damage, identify);
  }

  void _showEmote({String emote = 'emote/emote_exclamacao.png'}) {
    // Shows floating emote above player
    gameRef.add(
      AnimatedFollowerGameObject(
        animation: SpriteAnimation.load(
          emote,
          SpriteAnimationData.sequenced(
            amount: 8,
            stepTime: 0.1,
            textureSize: Vector2(32, 32),
          ),
        ),
        target: this,
        loop: false,
        size: Vector2.all(tileSize / 2),
        offset: Vector2(18, -6),
      ),
    );
  }

  void setContainKey(bool value) {
    debugPrint('[+] Knight => setContainKey: $value');
    debugPrint('[+] Knight => previous containKey: $containKey');
    if (containKey != value) {
      containKey = value;
      gameCubit.setHasKey(value);
      debugPrint('[+] Knight => new containKey: $containKey');
    }
  }
}
