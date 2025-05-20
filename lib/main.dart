import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tiny_satoshi/cubit/game/game_cubit.dart';
import 'package:tiny_satoshi/cubit/wallet/credentials_manager.dart';
import 'package:tiny_satoshi/cubit/wallet/wallet_cubit.dart';
import 'package:tiny_satoshi/main_app.dart';
import 'package:tiny_satoshi/services/keychain.dart';

final _log = Logger('Main');

void main() async {
  // Initialize Logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print('Stack trace: ${record.stackTrace}');
    }
  });

  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Flame.device.setLandscape();
      await Flame.device.fullScreen();

      final appDir = await getApplicationDocumentsDirectory();
      final keyChain = KeyChain();

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          p.join(appDir.path, "bloc_storage"),
        ),
      );

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<GameCubit>(create: (context) => GameCubit()),
            BlocProvider<WalletCubit>(
              create:
                  (context) =>
                      WalletCubit(CredentialsManager(keyChain: keyChain)),
            ),
          ],
          child: MainApp(),
        ),
      );
    },
    (error, stackTrace) async {
      if (error is! FlutterErrorDetails) {
        _log.severe("FlutterError: $error", error, stackTrace);
      }
    },
  );
}
