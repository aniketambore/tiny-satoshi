import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class CustomSpriteWidget extends StatelessWidget {
  final Future<Sprite> sprite;

  const CustomSpriteWidget({super.key, required this.sprite});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100, height: 100, child: sprite.asWidget());
  }
}
