import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tiny_satoshi/routes/main_menu/main_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_state.dart';

final _log = Logger('Dialogs');

class Dialogs {
  static final Map<String, BuildContext> _activeDialogs = {};

  static Future<T?> _showDialog<T>({
    required BuildContext context,
    required String dialogId,
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = false,
  }) async {
    _log.info('Showing dialog: $dialogId');
    _activeDialogs[dialogId] = context;

    final result = await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        _activeDialogs[dialogId] = dialogContext;
        return builder(dialogContext);
      },
    );

    _activeDialogs.remove(dialogId);
    _log.info('Dialog dismissed: $dialogId');
    return result;
  }

  static void dismissDialog(String dialogId) {
    _log.info('Attempting to dismiss dialog: $dialogId');
    final context = _activeDialogs[dialogId];
    if (context != null) {
      Navigator.of(context).pop();
      _activeDialogs.remove(dialogId);
      _log.info('Dialog dismissed: $dialogId');
    } else {
      _log.warning('No active dialog found with id: $dialogId');
    }
  }

  static void dismissAllDialogs() {
    _log.info('Attempting to dismiss all dialogs');
    for (final entry in _activeDialogs.entries) {
      Navigator.of(entry.value).pop();
    }
    _activeDialogs.clear();
    _log.info('All dialogs dismissed');
  }

  // Dialog IDs
  static const String _loadingWalletDialogId = 'loading_wallet';
  static const String _gameOverDialogId = 'game_over';
  static const String _sacredWordsDialogId = 'sacred_words';
  static const String _keyRequiredDialogId = 'key_required';
  static const String _chestRequiredDialogId = 'chest_required';
  static const String _receiveAddressDialogId = 'receive_address';
  static const String _loadingBalanceDialogId = 'loading_balance';
  static const String _faucetOptionsDialogId = 'faucet_options';
  static const String _congratulationsDialogId = 'congratulations';
  static const String _bitcoinTransferDialogId = 'bitcoin_transfer';
  static const String _walletErrorDialogId = 'wallet_error';

  static void showLoadingWalletDialog(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _loadingWalletDialogId,
      builder:
          (context) => Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 400,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 118, 82, 78),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Preparing Your Adventure',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Normal',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.amberAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Gathering your Bitcoin tools and preparing your journey into the realm...',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  static void dismissLoadingWalletDialog() {
    dismissDialog(_loadingWalletDialogId);
  }

  static void showGameOver(BuildContext context, VoidCallback playAgain) {
    _showDialog(
      context: context,
      dialogId: _gameOverDialogId,
      builder:
          (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/game_over.png', height: 100),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                  onPressed: () {
                    dismissDialog(_gameOverDialogId);
                    playAgain();
                  },
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  static void showSacredWordsDialog(BuildContext context, List<String> words) {
    _showDialog(
      context: context,
      dialogId: _sacredWordsDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              height:
                  MediaQuery.of(context).size.height *
                  0.9, // 90% of screen height
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Storyline Title
                    Text(
                      'The Sacred Words of Custody',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Normal',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    // Storyline Body
                    Text(
                      '"Guard these words with your life. Never share them. Never lose them."',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(100, 118, 82, 78),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            words.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${entry.key + 1}.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Normal',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Normal',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 118, 82, 78),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "I WILL GUARD THEM",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 17.0,
                        ),
                      ),
                      onPressed: () {
                        dismissDialog(_sacredWordsDialogId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showMnemonicVerificationDialog(
    BuildContext context,
    List<String> selectedWords,
    List<int> selectedPositions,
    Function(bool?) onVerificationComplete,
  ) {
    final controllers = List.generate(3, (_) => TextEditingController());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter the words in order',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: controllers[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Normal',
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Word ${selectedPositions[index]}',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Normal',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 118, 82, 78),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 118, 82, 78),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.amberAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onVerificationComplete(null);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Normal',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color.fromARGB(255, 118, 82, 78),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            final enteredWords =
                                controllers
                                    .map((c) => c.text.trim().toLowerCase())
                                    .toList();
                            final correctWords =
                                selectedWords
                                    .map((w) => w.toLowerCase())
                                    .toList();

                            if (enteredWords.every((word) => word.isNotEmpty) &&
                                const ListEquality().equals(
                                  enteredWords,
                                  correctWords,
                                )) {
                              Navigator.of(context).pop();
                              onVerificationComplete(true);
                            } else {
                              Navigator.of(context).pop();
                              onVerificationComplete(false);
                            }
                          },
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Normal',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showKeyRequiredDialog(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _keyRequiredDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Key Required',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'Normal',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'You need to find the key first to access this feature.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 118, 82, 78),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    onPressed: () => dismissDialog(_keyRequiredDialogId),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showChestRequiredDialog(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _chestRequiredDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chest Not Found',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'Normal',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'You need to find the chest first to receive Bitcoin.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 118, 82, 78),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    onPressed: () => dismissDialog(_chestRequiredDialogId),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showReceiveAddressDialog(BuildContext context, String address) {
    _showDialog(
      context: context,
      dialogId: _receiveAddressDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 350,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Bitcoin Receive Address',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Normal',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    QrImageView(
                      data: address,
                      version: QrVersions.auto,
                      size: 150.0,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      'Address: $address',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 118, 82, 78),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        dismissDialog(_receiveAddressDialogId);
                        await Clipboard.setData(ClipboardData(text: address));
                        Fluttertoast.showToast(
                          msg: "Address copied to clipboard!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          fontSize: 16.0,
                        );
                      },
                      child: Text(
                        'Copy Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showLoadingBalanceDialog(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _loadingBalanceDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Checking Balance',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'Normal',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.amberAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fetching your Bitcoin balance...',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void dismissLoadingBalanceDialog() {
    dismissDialog(_loadingBalanceDialogId);
  }

  static void showFaucetOptionsDialog(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _faucetOptionsDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bitcoin Testnet Faucets',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Normal',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Choose a faucet to get free testnet Bitcoin (tBTC):',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    _buildFaucetButton(
                      context,
                      'Coin Faucet',
                      'https://coinfaucet.eu/en/btc-testnet/',
                    ),
                    SizedBox(height: 10),
                    _buildFaucetButton(
                      context,
                      'Bitcoin Faucet UO1',
                      'https://bitcoinfaucet.uo1.net/',
                    ),
                    SizedBox(height: 10),
                    _buildFaucetButton(
                      context,
                      'Testnet Help',
                      'https://testnet.help/en/btcfaucet/testnet',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'After getting tBTC, come back and try opening the door again!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Normal',
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(100, 118, 82, 78),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Balance:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                ),
                              ),
                              BlocBuilder<WalletCubit, WalletState>(
                                builder: (context, state) {
                                  return Text(
                                    '${state.balance.toStringAsFixed(8)} BTC',
                                    style: TextStyle(
                                      color: Colors.amberAccent,
                                      fontFamily: 'Normal',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Color.fromARGB(255, 118, 82, 78),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              context.read<WalletCubit>().getBalance();
                            },
                            child: Text(
                              'Refresh Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Normal',
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 118, 82, 78),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      onPressed: () => dismissDialog(_faucetOptionsDialogId),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildFaucetButton(
    BuildContext context,
    String name,
    String url,
  ) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Color.fromARGB(255, 118, 82, 78),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            Fluttertoast.showToast(
              msg: "Could not launch $url",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      },
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Normal',
          fontSize: 16.0,
        ),
      ),
    );
  }

  static void showCongratulations(BuildContext context) {
    _showDialog(
      context: context,
      dialogId: _congratulationsDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'CONGRATULATIONS!',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontFamily: 'Normal',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Text(
                    "You've completed your journey in the Bitcoin realm!\n\nYou've learned about:\n• Securing your mnemonic phrase\n• Managing your Bitcoin wallet\n• Helping others in the Bitcoin community\n\nThank you for playing Tiny Satoshi!",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 118, 82, 78),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "FINISH",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 17.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainMenu()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showBitcoinTransferDialog(BuildContext context) {
    /// Savior wallet address
    const String kidAddress = 'tb1qktq44aefdt96hapee50679jqqp57ndrv9s5cud';
    const double amount = 0.00010000; // 10,000 sats
    const double fees = 0.00000100; // 100 sats in fees

    _showDialog(
      context: context,
      dialogId: _bitcoinTransferDialogId,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(200, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 118, 82, 78),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Help the Kid',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Normal',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'The kid needs some Bitcoin to pass through the final door.',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(100, 118, 82, 78),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '$amount BTC',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Network Fee:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '$fees BTC',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${amount + fees} BTC',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Kid\'s Address:',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Normal',
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SelectableText(
                        kidAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Normal',
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        if (state.isTransferring) {
                          return Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.amberAccent,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Processing Transfer...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Color.fromARGB(255, 118, 82, 78),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await context.read<WalletCubit>().sendBitcoin(
                                    addressStr: kidAddress,
                                    amount: amount,
                                    fee: fees,
                                  );
                                  if (context.mounted) {
                                    dismissDialog(_bitcoinTransferDialogId);
                                    showCongratulations(context);
                                  }
                                } catch (e, stackTrace) {
                                  if (context.mounted) {
                                    dismissDialog(_bitcoinTransferDialogId);
                                    showWalletErrorDialog(
                                      context,
                                      'Transfer failed: ${e.toString()}\n\nStack trace:\n$stackTrace',
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Approve Transfer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Normal',
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showWalletErrorDialog(BuildContext context, String error) {
    _showDialog(
      context: context,
      dialogId: _walletErrorDialogId,
      builder:
          (context) => Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 400,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 118, 82, 78),
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Wallet Creation Failed',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Normal',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'There was an error creating your wallet:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Normal',
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(100, 118, 82, 78),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          error,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Normal',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color.fromARGB(255, 118, 82, 78),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        onPressed: () => dismissDialog(_walletErrorDialogId),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Normal',
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
