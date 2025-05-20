import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bonfire/bonfire.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/utils/custom_sprite_animation_widget.dart';
import 'package:tiny_satoshi/widgets/dialogs.dart';
import 'dart:async' as async;

import 'package:tiny_satoshi/utils/player_sprite_sheet.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int currentPosition = 0;
  late async.Timer _timer;
  List<Future<SpriteAnimation>> sprites = [
    PlayerSpriteSheet.idleRight,
    PlayerSpriteSheet.runRight,
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: buildMenu(),
    );
  }

  Widget buildMenu() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/2.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    "Tiny Satoshi",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 54.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (sprites.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomSpriteAnimationWidget(
                                  animation: sprites[currentPosition],
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMenuButton('PLAY', () async {
                                final navigator = Navigator.of(context);
                                try {
                                  Dialogs.showLoadingWalletDialog(context);

                                  final walletCubit =
                                      context.read<WalletCubit>();
                                  final mnemonicList =
                                      await walletCubit.getMnemonic();
                                  if (mnemonicList != null) {
                                    final mnemonic = mnemonicList.join(' ');
                                    await walletCubit.connect(
                                      mnemonic: mnemonic,
                                    );
                                  } else {
                                    await walletCubit.connect(
                                      mnemonic: bip39.generateMnemonic(),
                                    );
                                  }

                                  if (!context.mounted) return;

                                  await Future.delayed(Duration(seconds: 2));
                                  Dialogs.dismissLoadingWalletDialog();

                                  // navigator.push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Game(),
                                  //   ),
                                  // );
                                  navigator.pushNamed('/game');
                                } catch (e) {
                                  Dialogs.dismissLoadingWalletDialog();

                                  if (context.mounted) {
                                    Dialogs.showWalletErrorDialog(
                                      context,
                                      e.toString(),
                                    );
                                  }
                                }
                              }),
                              SizedBox(height: 15),
                              _buildMenuButton('SHOP', () {
                                Navigator.pushNamed(context, '/shop');
                              }),
                              SizedBox(height: 15),
                              _buildMenuButton('CREDITS', () {
                                Navigator.pushNamed(context, '/credits');
                              }),
                              SizedBox(height: 15),
                              _buildMenuButton('EXIT', () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFF2D2B56),
                                      title: Text(
                                        'Exit Game',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Normal',
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to exit the game?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Normal',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Normal',
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            SystemNavigator.pop();
                                          },
                                          child: Text(
                                            'EXIT',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Normal',
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          minimumSize: Size(100, 45),
          backgroundColor: Color(0xFF2D2B56),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Normal',
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }

  void startTimer() {
    _timer = async.Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentPosition++;
        if (currentPosition > sprites.length - 1) {
          currentPosition = 0;
        }
      });
    });
  }
}
