import 'package:flutter/material.dart';
import 'package:walletconnect_modal_flutter/widgets/walletconnect_modal_theme.dart';

class WalletConnectModalNavbarTitle extends StatelessWidget {
  const WalletConnectModalNavbarTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: WalletConnectModalTheme.getData(context).foreground100,
      ),
      textAlign: TextAlign.center,
    );
  }
}
