import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:walletconnect_flutter_dapp/home_page.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isDark = true;
  List<Color> primaryColors = [
    WalletConnectModalThemeData.darkMode.primary100,
    WalletConnectModalThemeData.darkMode.primary090,
    WalletConnectModalThemeData.darkMode.primary080,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        final platformDispatcher = View.of(context).platformDispatcher;
        final platformBrightness = platformDispatcher.platformBrightness;
        _isDark = platformBrightness == Brightness.dark;
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    LoggerUtil.setLogLevel(Level.error);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final WalletConnectModalThemeData themeData = _isDark
        ? WalletConnectModalThemeData.darkMode
        : WalletConnectModalThemeData.lightMode;
    return WalletConnectModalTheme(
      data: themeData.copyWith(
        primary100: primaryColors[0],
        primary090: primaryColors[1],
        primary080: primaryColors[2],
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      final platformDispatcher = View.of(context).platformDispatcher;
      final platformBrightness = platformDispatcher.platformBrightness;
      _isDark = platformBrightness == Brightness.dark;
      _swapTheme();
    }
    super.didChangePlatformBrightness();
  }

  void _swapTheme() {
    setState(() {
      _isDark = !_isDark;
      if (_isDark &&
          primaryColors[0] == WalletConnectModalThemeData.darkMode.primary100) {
        primaryColors = [
          WalletConnectModalThemeData.lightMode.primary100,
          WalletConnectModalThemeData.lightMode.primary090,
          WalletConnectModalThemeData.lightMode.primary080,
        ];
      } else if (!_isDark &&
          primaryColors[0] ==
              WalletConnectModalThemeData.lightMode.primary100) {
        primaryColors = [
          WalletConnectModalThemeData.darkMode.primary100,
          WalletConnectModalThemeData.darkMode.primary090,
          WalletConnectModalThemeData.darkMode.primary080,
        ];
      }
    });
  }
}
