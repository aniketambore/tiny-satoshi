import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tiny_satoshi/game.dart';
import 'package:tiny_satoshi/routes/credits/credits_page.dart';
import 'package:tiny_satoshi/routes/shop/shop_page.dart';
import 'package:tiny_satoshi/routes/splash/splash_page.dart';

import 'routes/main_menu/main_menu.dart';

final _log = Logger('MainApp');

class MainApp extends StatelessWidget {
  final GlobalKey _appKey = GlobalKey();
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _appKey,
      title: 'Tiny Satoshi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Normal'),
      initialRoute: "splash",
      onGenerateRoute: (settings) {
        _log.info("New route: ${settings.name}");
        switch (settings.name) {
          case "splash":
            return MaterialPageRoute(
              builder: (context) => SplashPage(),
              settings: settings,
            );
          case "/":
            return CupertinoPageRoute(
              builder:
                  (_) => NavigatorPopHandler(
                    onPopWithResult:
                        (Object? result) =>
                            _homeNavigatorKey.currentState!.maybePop(),
                    child: Navigator(
                      initialRoute: "/",
                      key: _homeNavigatorKey,
                      onGenerateRoute: (settings) {
                        _log.info('New inner route: ${settings.name}');
                        switch (settings.name) {
                          case "/":
                            return CupertinoPageRoute(
                              builder: (_) => MainMenu(),
                              settings: settings,
                            );
                          case "/game":
                            return MaterialPageRoute(
                              builder: (_) => Game(),
                              settings: settings,
                            );
                          case "/shop":
                            return MaterialPageRoute(
                              builder: (_) => ShopPage(),
                              settings: settings,
                            );
                          case "/credits":
                            return MaterialPageRoute(
                              builder: (_) => CreditsPage(),
                              settings: settings,
                            );
                        }
                        assert(false);
                        return null;
                      },
                    ),
                  ),
              settings: settings,
            );
        }
        assert(false);
        return null;
      },
    );
  }
}
