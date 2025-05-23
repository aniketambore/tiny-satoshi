import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tiny_satoshi/player/player.dart';

class MyBarLifeComponent extends InterfaceComponent {
  // Bar dimensions
  double padding = 20;
  double widthBar = 90;
  double strokeWidth = 12;

  // Player stats
  double maxLife = 0;
  double life = 0;
  double maxStamina = 100;
  double stamina = 0;

  MyBarLifeComponent()
    : super(
        id: 1,
        position: Vector2(20, 20),
        spriteUnselected: Sprite.load("health_ui.png"),
        size: Vector2(120, 40),
      );

  @override
  void update(double dt) {
    if (gameRef.player != null) {
      life = gameRef.player!.life;
      maxLife = gameRef.player!.maxLife;
      if (gameRef.player is Knight) {
        stamina = (gameRef.player as Knight).stamina;
      }
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    try {
      _drawLife(canvas);
      _drawStamina(canvas);
    } catch (e) {
      debugPrint('[!] Error rendering bar life component: $e');
    }
    super.render(canvas);
  }

  void _drawLife(Canvas canvas) {
    double xBar = 29;
    double yBar = 10;
    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + widthBar, yBar),
      Paint()
        ..color = Colors.blueGrey[800]!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill,
    );

    double currentBarLife = (life * widthBar) / maxLife;

    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarLife, yBar),
      Paint()
        ..color = _getColorLife(currentBarLife)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill,
    );
  }

  void _drawStamina(Canvas canvas) {
    double xBar = 29;
    double yBar = 27;

    double currentBarStamina = (stamina * widthBar) / maxStamina;

    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarStamina, yBar),
      Paint()
        ..color = Colors.yellow
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill,
    );
  }

  Color _getColorLife(double currentBarLife) {
    if (currentBarLife > widthBar - (widthBar / 3)) {
      return Colors.green; // High health (>66%)
    }
    if (currentBarLife > (widthBar / 3)) {
      return Colors.yellow; // Medium health (33-66%)
    } else {
      return Colors.red; // Low health (<33%)
    }
  }
}
