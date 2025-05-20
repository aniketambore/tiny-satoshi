import 'package:bonfire/bonfire.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/player/player.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';

class DoorKey extends GameDecoration with Sensor {
  DoorKey(Vector2 position)
    : super.withSprite(
        sprite: Sprite.load('items/key_silver.png'),
        position: position,
        size: Vector2(tileSize, tileSize),
      );

  @override
  void onContact(GameComponent component) async {
    if (component is Knight) {
      component.setContainKey(true);

      // Get the wallet cubit from the context
      final walletCubit = gameRef.context.read<WalletCubit>();

      // Get the mnemonic words
      final words = (await walletCubit.getMnemonic())!;

      // Show the sacred words dialog
      if (gameRef.context.mounted) {
        Dialogs.showSacredWordsDialog(gameRef.context, words);
      }

      removeFromParent();
    }
  }
}
