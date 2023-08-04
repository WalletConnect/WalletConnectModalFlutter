import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/models/walletconnect_modal_theme_data.dart';

class WalletConnectModalTheme extends InheritedWidget {
  const WalletConnectModalTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final WalletConnectModalThemeData data;

  static WalletConnectModalTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WalletConnectModalTheme>();
  }

  static WalletConnectModalTheme of(BuildContext context) {
    final WalletConnectModalTheme? result = maybeOf(context);
    assert(result != null, 'No WalletConnectModal theme found in context');
    return result!;
  }

  static WalletConnectModalThemeData getData(BuildContext context) {
    final WalletConnectModalTheme? theme = maybeOf(context);
    return theme?.data ?? WalletConnectModalThemeData.lightMode;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
