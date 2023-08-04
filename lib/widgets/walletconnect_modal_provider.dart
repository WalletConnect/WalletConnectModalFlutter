import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

class WalletConnectModalProvider extends InheritedWidget {
  final IWalletConnectModalService service;

  const WalletConnectModalProvider({
    super.key,
    required this.service,
    required super.child,
  });

  static WalletConnectModalProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WalletConnectModalProvider>();
  }

  static WalletConnectModalProvider of(BuildContext context) {
    final WalletConnectModalProvider? result = maybeOf(context);
    assert(result != null, 'No WalletConnectModalProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(WalletConnectModalProvider oldWidget) {
    return true;
  }
}
