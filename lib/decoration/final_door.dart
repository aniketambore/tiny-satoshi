import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class FinalDoor extends GameDecoration {
  bool open = false; // Track if door is open
  bool showDialog = false; // Track if showing dialog
  bool isBalanceLoading = false; // Track if loading balance
  RectangleHitbox? _hitbox; // Store reference to hitbox

  FinalDoor(Vector2 position, Vector2 size)
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
      if (!open && !showDialog && !isBalanceLoading) {
        showDialog = true;
        isBalanceLoading = true;

        // Show loading dialog
        Dialogs.showLoadingBalanceDialog(gameRef.context);

        try {
          // Fetch balance
          final walletCubit = gameRef.context.read<WalletCubit>();
          await walletCubit.sync();
          await walletCubit.getBalance();

          // Only proceed if we're still in loading state
          if (isBalanceLoading) {
            isBalanceLoading = false;

            // Close the loading dialog
            if (gameRef.context.mounted) {
              Dialogs.dismissLoadingBalanceDialog();
            }

            // Check if the context is still mounted before showing new dialog
            if (gameRef.context.mounted) {
              if (walletCubit.state.balance > 0) {
                _openDoor();
              } else {
                _showInsufficientBalanceDialog();
              }
            }
          }
        } catch (e) {
          // Handle any errors during balance fetching
          if (isBalanceLoading) {
            isBalanceLoading = false;

            // Close the loading dialog
            if (gameRef.context.mounted) {
              Dialogs.dismissLoadingBalanceDialog();
            }

            if (gameRef.context.mounted) {
              _showErrorDialog();
            }
          }
        }
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _openDoor() async {
    open = true;
    // Change the door sprite to open
    sprite = await Sprite.load('items/door_open.png');
    if (_hitbox != null) {
      _hitbox!.size = Vector2(width * 0.2, height / 4);
    }
  }

  void _showInsufficientBalanceDialog() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  'Your wallet is empty! You need some Bitcoin to pass through this door.',
            ),
          ],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(
              text:
                  'Since this is a testnet game, you can get free testnet Bitcoin (tBTC) from a faucet!',
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
          if (gameRef.context.mounted) {
            Dialogs.showFaucetOptionsDialog(gameRef.context);
          }
        });
      },
    );
  }

  void _showErrorDialog() {
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [
            TextSpan(
              text:
                  'Oops! Something went wrong while checking your balance. Please try again.',
            ),
          ],
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
