import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiny_satoshi/enemies/boss.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/npc_spritesheet.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class Kid extends GameDecoration {
  bool conversationWithHero = false;

  Kid(Vector2 position)
    : super.withAnimation(
        animation: NpcSpriteSheet.kidIdleLeft(),
        position: position,
        size: Vector2(valueByTileSize(8), valueByTileSize(11)),
      );

  @override
  void update(double dt) {
    super.update(dt);
    if (!conversationWithHero && checkInterval('checkBossDead', 1000, dt)) {
      try {
        gameRef.enemies().firstWhere((e) => e is Boss);
      } catch (e) {
        conversationWithHero = true;
        gameRef.camera.moveToTargetAnimated(
          target: this,
          onComplete: () {
            _startConversation();
          },
        );
      }
    }
  }

  void _startConversation() {
    // Sounds.interaction();
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  'Thank the gods! You saved me from that horrible Bitcoin thief!',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'He was trying to perform a \$5 wrench attack on me! He wanted to force me to give up my Bitcoin wallet\'s private keys!',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'I was on my way to the final door when he ambushed me. That\'s why it\'s so important to never share your private keys with anyone, no matter what!',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'I need to get to the final door, but I need some Bitcoin to pass through. Could you help me with that?',
            ),
          ],
          person: CustomSpriteAnimationWidget(
            animation: NpcSpriteSheet.kidIdleLeft(),
          ),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onFinish: () {
        // Sounds.interaction();
        gameRef.camera.moveToPlayerAnimated(
          onComplete: () {
            Dialogs.showBitcoinTransferDialog(gameRef.context);
          },
        );
      },
      onChangeTalk: (index) {
        // Sounds.interaction();
      },
      logicalKeyboardKeysToNext: [LogicalKeyboardKey.space],
    );
  }
}
