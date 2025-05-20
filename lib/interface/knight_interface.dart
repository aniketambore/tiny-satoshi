import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/interface/bar_life_component.dart';
import 'package:tiny_satoshi/player/player.dart';

class KnightInterface extends GameInterface {
  late Sprite keySprite; // Image for the key icon

  @override
  Future<void> onLoad() async {
    // Load the key image
    keySprite = await Sprite.load('items/key_silver.png');
    // Add the life/stamina bars
    add(MyBarLifeComponent());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      _drawKey(canvas);
    } catch (e) {
      debugPrint('[!] Error rendering knight interface: $e');
    }
    super.render(canvas);
  }

  void _drawKey(Canvas canvas) {
    if (gameRef.player != null && (gameRef.player as Knight).containKey) {
      keySprite.renderRect(canvas, Rect.fromLTWH(150, 20, 35, 30));
    }
  }
}
