import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';

class Fountain extends GameDecoration {
  bool empty = false;

  Fountain(Vector2 position, {this.empty = false})
    : super.withAnimation(
        animation: GameSpriteSheet.fountain(),
        position: position,
        size: Vector2.all(tileSize),
      ) {
    setupLighting(
      LightingConfig(
        radius: width * 2.5,
        blurBorder: width,
        pulseVariation: 0.1,
        color: Colors.deepOrangeAccent.withValues(alpha: 0.2),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (!empty) {
      super.render(canvas);
    }
  }
}

class FountainBlue extends GameDecoration {
  bool empty = false;

  FountainBlue(Vector2 position, {this.empty = false})
    : super.withAnimation(
        animation: GameSpriteSheet.fountainBlue(),
        position: position,
        size: Vector2.all(tileSize),
      ) {
    setupLighting(
      LightingConfig(
        radius: width * 2.5,
        blurBorder: width,
        pulseVariation: 0.1,
        color: Colors.blue.withValues(alpha: 0.2),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (!empty) {
      super.render(canvas);
    }
  }
}
