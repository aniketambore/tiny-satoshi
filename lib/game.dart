import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/game/game_cubit.dart';
import 'package:tiny_satoshi/decoration/door.dart';
import 'package:tiny_satoshi/decoration/empty_chest.dart';
import 'package:tiny_satoshi/decoration/final_door.dart';
import 'package:tiny_satoshi/decoration/fountain.dart';
import 'package:tiny_satoshi/decoration/key.dart';
import 'package:tiny_satoshi/decoration/potion_life.dart';
import 'package:tiny_satoshi/decoration/skull.dart';
import 'package:tiny_satoshi/decoration/spikes.dart';
import 'package:tiny_satoshi/enemies/boss.dart';
import 'package:tiny_satoshi/enemies/goblin.dart';
import 'package:tiny_satoshi/enemies/imp.dart';
import 'package:tiny_satoshi/enemies/mini_boss.dart';
import 'package:tiny_satoshi/interface/knight_interface.dart';
import 'package:tiny_satoshi/npc/kid.dart';
import 'package:tiny_satoshi/npc/wizard_npc.dart';
import 'package:tiny_satoshi/utils/constants.dart';
import 'package:tiny_satoshi/utils/functions.dart';
import 'package:tiny_satoshi/utils/sounds.dart';
import 'package:tiny_satoshi/widgets/game_controller.dart';
import 'player/player.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: const _GameContent(),
    );
  }
}

class _GameContent extends StatefulWidget {
  const _GameContent();

  @override
  State<_GameContent> createState() => _GameContentState();
}

class _GameContentState extends State<_GameContent> {
  @override
  void initState() {
    Sounds.playBackgroundSound();
    super.initState();
  }

  @override
  void dispose() {
    Sounds.stopBackgroundSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameCubit = context.read<GameCubit>();
    final player = Knight(
      Vector2(2 * tileSize, 3 * tileSize),

      /// Near Key Location
      // Vector2(35 * tileSize, 20 * tileSize),

      /// Near Door Location
      // Vector2(8 * tileSize, 18 * tileSize),

      /// Near Kid Location
      // Vector2(5 * tileSize, 35 * tileSize),
      gameCubit: gameCubit,
    );

    final actions = [
      JoystickAction(
        actionId: 0,
        sprite: Sprite.load('joystick_attack.png'),
        spritePressed: Sprite.load('joystick_attack_selected.png'),
        size: 80,
        margin: EdgeInsets.only(bottom: 50, right: 50),
      ),
      JoystickAction(
        actionId: 1,
        sprite: Sprite.load('joystick_attack_range.png'),
        spritePressed: Sprite.load('joystick_attack_range_selected.png'),
        size: 50,
        margin: EdgeInsets.only(bottom: 50, right: 160),
      ),
      JoystickAction(
        actionId: 2,
        sprite: Sprite.load('items/skull.png'),
        spritePressed: Sprite.load('items/skull.png'),
        size: 50,
        margin: topRightJoystickMargin(context, right: 40),
      ),
      JoystickAction(
        actionId: 3,
        sprite: Sprite.load('items/chest_closed.png'),
        spritePressed: Sprite.load('items/chest_closed.png'),
        size: 30,
        margin: topRightJoystickMargin(context, right: 90, top: 5),
      ),
    ];

    PlayerController joystick = Joystick(
      directional: JoystickDirectional(
        spriteBackgroundDirectional: Sprite.load('joystick_background.png'),
        spriteKnobDirectional: Sprite.load('joystick_knob.png'),
        size: 100,
        isFixed: false,
      ),
      actions: actions,
    );

    return MaterialApp(
      color: Colors.transparent,
      home: BonfireWidget(
        playerControllers: [joystick],
        player: player,
        map: WorldMapByTiled(
          WorldMapReader.fromAsset('tiled/tile_map.json'),
          forceTileSize: Vector2(tileSize, tileSize),
          objectsBuilder: {
            'fountain': (p) => Fountain(p.position),
            'fountain_blue': (p) => FountainBlue(p.position),
            'wizard': (p) => WizardNPC(p.position),
            'goblin': (p) => Goblin(p.position),
            'imp': (p) => Imp(p.position),
            'spikes': (p) => Spikes(p.position),
            'key': (p) => DoorKey(p.position),
            'potion': (p) => PotionLife(p.position, 30),
            'door': (p) => Door(p.position, p.size),
            'door_top': (p) => DoorTop(p.position, p.size),
            'skull': (p) => Skull(p.position),
            'empty_chest': (p) => EmptyChest(p.position, p.size),
            'mini_boss': (p) => MiniBoss(p.position),
            'final_door': (p) => FinalDoor(p.position, p.size),
            'boss': (p) => Boss(p.position),
            'kid': (p) => Kid(p.position),
          },
        ),
        components: [GameController()],
        interface: KnightInterface(),
        lightingColorGame: Colors.black.withValues(alpha: 0.6),
        backgroundColor: Colors.grey[900]!,
        cameraConfig: CameraConfig(
          speed: 3,
          zoom: getZoomFromMaxVisibleTile(context, tileSize, 18),
        ),
      ),
    );
  }
}
