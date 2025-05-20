import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/game.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class GameController extends GameComponent {
  bool showGameOver = false;
  @override
  void update(double dt) {
    if (checkInterval('gameOver', 100, dt)) {
      if (gameRef.player != null && gameRef.player?.isDead == true) {
        if (!showGameOver) {
          showGameOver = true;
          _showDialogGameOver();
        }
      }
    }
    super.update(dt);
  }

  void _showDialogGameOver() {
    showGameOver = true;
    Dialogs.showGameOver(context, () {
      Navigator.of(context).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Game()),
          (route) => false,
        );
      });
    });
  }
}
