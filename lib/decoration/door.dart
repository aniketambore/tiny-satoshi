import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';
import 'dart:math';

class Door extends GameDecoration {
  bool open = false; // Track if door is open
  bool showDialog = false; // Track if showing dialog
  RectangleHitbox? _hitbox; // Store reference to hitbox
  final _random = Random(); // For selecting random words

  Door(Vector2 position, Vector2 size)
    : super.withSprite(
        sprite: Sprite.load('items/door_closed.png'),
        position: position,
        size: size,
      );

  @override
  Future<void> onLoad() {
    _hitbox = RectangleHitbox(
      size: Vector2(width, height / 4), // Hitbox is 1/4 height
      position: Vector2(0, height * 0.75), // Positioned at bottom
    );
    add(_hitbox!);
    return super.onLoad();
  }

  @override
  Future<void> onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    if (other is Knight) {
      // Check if player collided
      if (!open) {
        // If door is still closed
        Knight p = other;

        if (p.containKey == true) {
          // Player has key
          if (!showDialog) {
            showDialog = true;
            _showMnemonicVerification();
          }
        } else {
          // Show dialog if player doesn't have key
          if (!showDialog) {
            showDialog = true;
            _showIntroduction();
          }
        }
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _showMnemonicVerification() async {
    final walletCubit = gameRef.context.read<WalletCubit>();
    final mnemonicWords = (await walletCubit.getMnemonic())!;

    // Select 3 random positions (1-based for user display)
    final positions = List.generate(12, (i) => i + 1)..shuffle(_random);
    final selectedPositions = positions.take(3).toList()..sort();
    final selectedWords =
        selectedPositions.map((pos) => mnemonicWords[pos - 1]).toList();

    // Show verification dialog
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  'To prove you remember your mnemonic, please enter these words:',
            ),
          ],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Word ${selectedPositions[0]}, Word ${selectedPositions[1]}, and Word ${selectedPositions[2]}',
            ),
          ],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onClose: () {
        showDialog = false;
        // Add a small delay to ensure the TalkDialog is fully closed
        Future.delayed(Duration(milliseconds: 100), () {
          _showVerificationInput(selectedWords, selectedPositions);
        });
      },
    );
  }

  void _showVerificationInput(
    List<String> selectedWords,
    List<int> selectedPositions,
  ) async {
    Dialogs.showMnemonicVerificationDialog(
      gameRef.context,
      selectedWords,
      selectedPositions,
      (success) {
        if (success == true) {
          _openDoor();
        } else if (success == false) {
          _showVerificationFailed(selectedWords, selectedPositions);
        }
        // If success is null, it means the user cancelled - do nothing
      },
    );
  }

  void _showVerificationFailed(
    List<String> selectedWords,
    List<int> selectedPositions,
  ) {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: 'That\'s not correct! Please try again.')],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onClose: () {
        showDialog = false;
        // Add a small delay to ensure the TalkDialog is fully closed
        Future.delayed(Duration(milliseconds: 100), () {
          _showVerificationInput(selectedWords, selectedPositions);
        });
      },
    );
  }

  Future<void> _openDoor() async {
    open = true;
    if (gameRef.player != null && gameRef.player is Knight) {
      // (gameRef.player as Knight).setContainKey(false); // Use up the key
    }

    // Change the door sprite to open
    sprite = await Sprite.load('items/door_open.png');
    if (_hitbox != null) {
      _hitbox!.size = Vector2(width * 0.2, height / 4);
    }
  }

  void _showIntroduction() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: 'I think I need a key to get through here!')],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onClose: () {
        showDialog = false;
      },
    );
  }
}

class DoorTop extends GameDecoration {
  DoorTop(Vector2 position, Vector2 size)
    : super.withSprite(
        sprite: Sprite.load('items/door_top.png'),
        position: position,
        size: size,
      );
}
