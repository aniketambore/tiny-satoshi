import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/game_sprite_sheet.dart';
import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class EmptyChest extends GameDecoration {
  bool open = false; // Track if chest is open
  bool isDialogShowing = false; // Track if showing dialog

  EmptyChest(Vector2 position, Vector2 size)
    : super.withSprite(
        sprite: Sprite.load('items/chest_closed.png'),
        position: position,
        size: size,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      RectangleHitbox(
        size: Vector2(width, height / 2),
        position: Vector2(0, height * 0.55),
      ),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    // Check if the collision is with the player
    if (other is Knight) {
      // Check if the chest is not already open
      if (!open) {
        open = true;

        Knight p = other;
        p.containChest = true;

        playSpriteAnimationOnce(
          GameSpriteSheet.chestOpen(),
          onFinish: () {
            _showEmptyWalletDialog();
          },
          onStart: () {},
        );

        open = false;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _showEmptyWalletDialog() {
    if (isDialogShowing) return;
    isDialogShowing = true;
    TalkDialog.show(
      gameRef.context,
      [
        Say(
          text: [TextSpan(text: 'The chest is empty...')],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
        Say(
          text: [
            TextSpan(
              text: 'Looks like you don\'t have any balance in your wallet!',
            ),
          ],
          person: PlayerSpriteSheet.idleRight.asWidget(),
          personSayDirection: PersonSayDirection.LEFT,
        ),
      ],
      onClose: () {
        Future.delayed(Duration(milliseconds: 100), () {
          _showReceiveAddressDialog();
        });
      },
    );
  }

  void _showReceiveAddressDialog() async {
    final context = gameRef.context;
    final walletCubit = context.read<WalletCubit>();
    final address = await walletCubit.getReceiveAddress();
    Dialogs.showReceiveAddressDialog(context, address);
  }
}
