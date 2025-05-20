import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/npc_spritesheet.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';

class WizardNPC extends SimpleNpc {
  bool _showConversation = false;

  WizardNPC(Vector2 position)
    : super(
        animation: SimpleDirectionAnimation(
          idleRight: NpcSpriteSheet.wizardIdleLeft(),
          runRight: NpcSpriteSheet.wizardIdleLeft(),
        ),
        position: position,
        size: Vector2(tileSize * 0.8, tileSize),
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
    if (gameRef.player != null) {
      seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!_showConversation) {
            gameRef.player!.idle();
            _showConversation = true;
            _showEmote(emote: 'emote/emote_interregacao.png');
            _showIntroduction();
          }
        },
        radiusVision: (2 * tileSize),
      );
    }
  }

  void _showEmote({String emote = 'emote/emote_exclamacao.png'}) {
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
        loop: false,
        target: this,
        offset: Vector2(18, -6),
        size: Vector2.all(tileSize / 2),
      ),
    );
  }

  void _showIntroduction() {
    TalkDialog.show(gameRef.context, [
      Say(
        text: [
          TextSpan(
            text:
                'Ah, a new traveler! Welcome, Tiny Satoshi.\nI am Sage Satoshi, your guide in these shadowy halls.',
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [TextSpan(text: 'Where am I? What is this place?')],
        person: CustomSpriteAnimationWidget(
          animation: PlayerSpriteSheet.idleRight,
        ),
        personSayDirection: PersonSayDirection.LEFT,
      ),
      Say(
        text: [
          TextSpan(
            text:
                'This is the Dungeon of Custody. Here, you’ll learn to protect your own Bitcoin—starting with a secret phrase called a mnemonic.',
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [TextSpan(text: 'A secret phrase?')],
        person: CustomSpriteAnimationWidget(
          animation: PlayerSpriteSheet.idleRight,
        ),
        personSayDirection: PersonSayDirection.LEFT,
      ),
      Say(
        text: [
          TextSpan(
            text:
                'Yes! Twelve special words that keep your wallet safe. Guard them well—only you should know them.',
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
            text:
                'Ready to begin your adventure? Follow the path, and remember.....',
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [TextSpan(text: 'Remember what?')],
        person: CustomSpriteAnimationWidget(
          animation: PlayerSpriteSheet.idleRight,
        ),
        personSayDirection: PersonSayDirection.LEFT,
      ),
      Say(
        text: [TextSpan(text: 'Not your keys, not your coins!')],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
      Say(
        text: [
          TextSpan(
            text:
                'Now, step forward, Tiny Satoshi. Your adventure—and your lesson—begins!',
          ),
        ],
        person: CustomSpriteAnimationWidget(
          animation: NpcSpriteSheet.wizardIdleLeft(),
        ),
        personSayDirection: PersonSayDirection.RIGHT,
      ),
    ]);
  }
}
