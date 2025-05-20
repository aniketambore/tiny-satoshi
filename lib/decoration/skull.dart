import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/custom_sprite_widget.dart';
import 'package:tiny_satoshi/utils/npc_spritesheet.dart';

class Skull extends GameDecoration with Sensor {
  bool showDialog = false;
  bool storyShown = false;

  Skull(Vector2 position)
    : super.withSprite(
        sprite: NpcSpriteSheet.skull(),
        position: position,
        size: Vector2(tileSize, tileSize),
      ) {
    setupLighting(
      LightingConfig(
        radius: width * 1.5,
        blurBorder: width,
        pulseVariation: 0.1,
        color: Colors.amber.withValues(alpha: 0.2),
      ),
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is Knight && !showDialog && !storyShown) {
      showDialog = true;
      _showStory();
    }
  }

  void _showStory() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  'Ah, another traveler... I was once like you, full of hope and dreams of financial freedom.',
            ),
          ],
          person: CustomSpriteWidget(sprite: NpcSpriteSheet.skull()),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'I too had my Bitcoin wallet, my keys to the future. But I was careless...',
            ),
          ],
          person: CustomSpriteWidget(sprite: NpcSpriteSheet.skull()),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'I stored my mnemonic phrase in a "safe" place - my phone\'s notes. One day, my phone broke, and with it, my access to my Bitcoin fortune.',
            ),
          ],
          person: CustomSpriteWidget(sprite: NpcSpriteSheet.skull()),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Remember, young one: Your mnemonic phrase is your key to your Bitcoin. Write it down on paper, keep it in a secure place, and never share it with anyone.',
            ),
          ],
          person: CustomSpriteWidget(sprite: NpcSpriteSheet.skull()),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Not even the most trusted friend, not even a family member. Your keys, your Bitcoin. Not your keys, not your Bitcoin.',
            ),
          ],
          person: CustomSpriteWidget(sprite: NpcSpriteSheet.skull()),
          personSayDirection: PersonSayDirection.RIGHT,
        ),
      ],
      onClose: () {
        showDialog = false;
        storyShown = true;
      },
    );
  }
}
